import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/ambience.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/states.dart';
import '../../data/models/diagnosis.dart';
import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/farmer_shell.dart';
import '../home/home_providers.dart';

/// Every photo the farmer has taken, newest first.
///
/// Queued (not-yet-uploaded) photos are shown inline with a sync chip rather
/// than hidden until they succeed — FR-27's whole promise is that an offline
/// capture is not lost, so it has to be visible.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _pendingOnly = false;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final async = ref.watch(diagnosisHistoryProvider);

    return AppScreen(
      title: l.diagnosisHistoryTitle,
      bottomNav: const FarmerNav(current: FarmerTab.history),
      fab: const FarmerMicFab(),
      ambience: AmbienceMood.records,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: Space.xs,
            runSpacing: Space.xxs,
            children: [
              FilterChip(
                label: Text(l.filterAll),
                selected: !_pendingOnly,
                onSelected: (_) => setState(() => _pendingOnly = false),
              ),
              FilterChip(
                label: Text(l.filterUncertain),
                selected: _pendingOnly,
                onSelected: (_) => setState(() => _pendingOnly = true),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          async.when(
            loading: () => const LoadingState(rows: 4),
            error: (_, _) => ErrorState(
              onRetry: () => ref.invalidate(diagnosisHistoryProvider),
            ),
            data: (all) {
              final items = _pendingOnly
                  ? all
                      .where((d) => d.isPendingReview || d.needsRetake)
                      .toList()
                  : all;

              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.photo_camera_rounded,
                  title: l.diagnosisHistoryEmptyTitle,
                  body: l.diagnosisHistoryEmptyBody,
                  actionLabel: l.homeTileCheckCrop,
                  onAction: () => context.push(Routes.capture),
                );
              }

              return Column(
                children: [
                  for (final d in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.xs),
                      child: _HistoryTile(diagnosis: d),
                    ),
                  const SizedBox(height: Space.md),
                  Text(
                    l.aiDisclaimer,
                    textAlign: TextAlign.center,
                    style: context.texts.bodySmall
                        ?.copyWith(color: p.onSurfaceMuted),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.diagnosis});

  final Diagnosis diagnosis;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final d = diagnosis;
    final f = AppFormat.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final headline = d.canShowDisease
        ? (d.disease?.label(locale) ?? l.diagnosisResultTitle)
        : (d.needsRetake ? l.diagnosisRetake : l.diagnosisLowTitle);

    return AppCard(
      padding: const EdgeInsets.all(Space.sm),
      onTap: () => context.push('${Routes.result}?id=${d.id}'),
      semanticLabel: '$headline, ${f.relative(d.createdAt)}',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Sizes.listThumbnail,
            height: Sizes.listThumbnail,
            decoration: BoxDecoration(
              color: p.surfaceSunken,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: p.outline, width: p.borderWidth),
            ),
            child: Icon(
              d.isHealthy ? Icons.eco_rounded : Icons.local_florist_rounded,
              color: p.primary,
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: context.texts.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  f.dateTime(d.createdAt),
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                ),
                const SizedBox(height: Space.xxs),
                Wrap(
                  spacing: Space.xs,
                  runSpacing: Space.xxs,
                  children: [
                    if (d.canShowDisease)
                      ConfidenceBadge(
                        score: d.confidence,
                        level: d.confidenceLevel,
                      ),
                    if (d.reviewedByExpert)
                      const VerifiedBadge(verified: true),
                    if (d.syncStatus != SyncStatus.synced)
                      SyncStatusChip(status: d.syncStatus),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.onSurfaceMuted),
        ],
      ),
    );
  }
}
