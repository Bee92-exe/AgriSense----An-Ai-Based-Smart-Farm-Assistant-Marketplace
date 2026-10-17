import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/session_provider.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/states.dart';
import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';

/// Where a vendor or expert waits after registering.
///
/// This is a real screen rather than a blocked state because the SRS's UC-12
/// alternate flow is "the account stays unverified until the admin approves it",
/// and a user who has just handed over their trade licence needs to see that it
/// went somewhere.
class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: LoadingState(rows: 2));
    }

    final isVendor = user.role == Role.vendor;
    final shop = user.vendor?.shopName;
    final specialization = user.expert?.specialization;

    return Scaffold(
      backgroundColor: p.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.md),
          children: [
            const SizedBox(height: Space.xl),
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.harvestContainer,
                shape: BoxShape.circle,
                border: Border.all(
                  color: p.onHarvestContainer,
                  width: p.borderWidth,
                ),
              ),
              child: Icon(
                Icons.hourglass_top_rounded,
                size: 48,
                color: p.onHarvestContainer,
              ),
            ),
            const SizedBox(height: Space.md),
            Text(
              l.pendingTitle,
              textAlign: TextAlign.center,
              style: context.texts.titleLarge,
            ),
            const SizedBox(height: Space.xs),
            Text(
              l.pendingBody,
              textAlign: TextAlign.center,
              style: context.texts.bodyMedium?.copyWith(
                color: p.onSurfaceMuted,
              ),
            ),
            const SizedBox(height: Space.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListRow(
                    title: user.name,
                    subtitle: user.mobile,
                    leading: CircleAvatar(
                      backgroundColor: p.primaryContainer,
                      child: Text(
                        user.initials,
                        style: context.texts.labelLarge
                            ?.copyWith(color: p.onPrimaryContainer),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListRow(
                    title: isVendor ? l.roleVendor : l.roleExpert,
                    subtitle: isVendor ? shop : specialization,
                    leading: Icon(
                      isVendor
                          ? Icons.storefront_rounded
                          : Icons.school_rounded,
                      color: p.onSurfaceMuted,
                    ),
                    trailing: const VerifiedBadge(verified: false),
                  ),
                  const Divider(),
                  ListRow(
                    title: l.registerDistrictLabel,
                    subtitle: user.district,
                    leading: Icon(Icons.place_outlined, color: p.onSurfaceMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.lg),
            AppButton(
              label: l.actionRetry,
              tone: AppButtonTone.secondary,
              icon: Icons.refresh_rounded,
              // Re-reads the session, which is how the status change would arrive
              // once a real backend exists.
              onPressed: () => ref.invalidate(sessionProvider),
            ),
            const SizedBox(height: Space.xs),
            AppButton(
              label: l.profileLogout,
              tone: AppButtonTone.quiet,
              onPressed: () => ref.read(sessionProvider.notifier).logout(),
            ),
          ],
        ),
      ),
    );
  }
}
