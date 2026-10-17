import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/labels.dart';
import '../../core/widgets/ambience.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/states.dart';
import '../../data/models/enums.dart';
import '../../data/models/news_item.dart';
import '../../data/providers.dart';
import '../../data/repositories/news_repository.dart';
import '../../l10n/app_localizations.dart';

/// Filter state for the news list. Kept as a provider so the filter survives a
/// trip into an item and back.
class _NewsFilter extends Notifier<NewsQuery> {
  @override
  NewsQuery build() => const NewsQuery();

  void setCrop(CropType? crop) => state = crop == null
      ? state.copyWith(clearCrop: true)
      : state.copyWith(crop: crop);

  void setCategory(NewsCategory? category) => state = category == null
      ? state.copyWith(clearCategory: true)
      : state.copyWith(category: category);
}

final _newsFilterProvider =
    NotifierProvider<_NewsFilter, NewsQuery>(_NewsFilter.new);

final _newsListProvider = FutureProvider<List<NewsItem>>((ref) async {
  final query = ref.watch(_newsFilterProvider);
  return ref.watch(newsRepositoryProvider).list(query: query);
});

/// Krishi Barta, ordered urgent first then newest.
///
/// The urgent strip is pinned above the filters so it cannot be filtered away —
/// a farmer with a potato filter should still see a rice outbreak that affects
/// their district.
class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final filter = ref.watch(_newsFilterProvider);
    final async = ref.watch(_newsListProvider);

    return AppScreen(
      title: l.navNews,
      ambience: AmbienceMood.news,
      actions: [
        IconButton(
          tooltip: l.actionRetry,
          onPressed: () => ref.invalidate(_newsListProvider),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final crop in CropType.values) ...[
                  FilterChip(
                    label: Text(crop.label(l)),
                    selected: filter.crop == crop,
                    onSelected: (v) => ref
                        .read(_newsFilterProvider.notifier)
                        .setCrop(v ? crop : null),
                  ),
                  const SizedBox(width: Space.xs),
                ],
              ],
            ),
          ),
          const SizedBox(height: Space.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in NewsCategory.values) ...[
                  FilterChip(
                    avatar: Icon(category.icon, size: 18),
                    label: Text(category.label(l)),
                    selected: filter.category == category,
                    onSelected: (v) => ref
                        .read(_newsFilterProvider.notifier)
                        .setCategory(v ? category : null),
                  ),
                  const SizedBox(width: Space.xs),
                ],
              ],
            ),
          ),
          const SizedBox(height: Space.md),
          async.when(
            loading: () => const LoadingState(rows: 4),
            error: (_, _) => ErrorState(
              onRetry: () => ref.invalidate(_newsListProvider),
            ),
            data: (items) {
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.campaign_outlined,
                  title: l.stateEmptyTitle,
                  body: l.stateEmptyBody,
                  actionLabel: l.actionRetry,
                  onAction: () => ref
                      .read(_newsFilterProvider.notifier)
                      .setCrop(null),
                );
              }
              return Column(
                children: [
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.xs),
                      child: _NewsTile(item: item),
                    ),
                  const SizedBox(height: Space.sm),
                  Text(
                    l.weatherUpdated(
                      AppFormat.of(context).relative(items.first.publishedAt),
                    ),
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

class _NewsTile extends ConsumerWidget {
  const _NewsTile({required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final f = AppFormat.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return AppCard(
      padding: const EdgeInsets.all(Space.sm),
      onTap: () async {
        await ref.read(newsRepositoryProvider).markRead(item.id);
        ref.invalidate(_newsListProvider);
        if (context.mounted) context.push('/news/${item.id}');
      },
      semanticLabel: item.title(locale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.isUrgent ? p.errorContainer : p.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.category.icon,
              color: item.isUrgent ? p.error : p.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title(locale),
                        style: context.texts.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!item.isRead) ...[
                      const SizedBox(width: Space.xs),
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          color: p.primary,
                          shape: BoxShape.circle,
                        ),
                        // Read state is announced, not just coloured.
                        child: Semantics(label: l.actionSeeAll),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: Space.xxs),
                Text(
                  item.summary(locale),
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Space.xs),
                Wrap(
                  spacing: Space.xs,
                  runSpacing: Space.xxs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SeverityChip(severity: item.severity, compact: true),
                    Text(
                      item.source.name,
                      style: context.texts.bodySmall
                          ?.copyWith(color: p.onSurfaceMuted),
                    ),
                    Text(
                      f.relative(item.publishedAt),
                      style: context.texts.bodySmall
                          ?.copyWith(color: p.onSurfaceMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
