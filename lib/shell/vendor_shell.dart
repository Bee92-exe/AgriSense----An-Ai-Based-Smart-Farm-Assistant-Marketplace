import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/session_provider.dart';
import '../core/theme/app_metrics.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_card.dart';
import '../core/widgets/states.dart';
import '../data/models/enums.dart';
import '../l10n/app_localizations.dart';

/// The shell for the three non-farmer roles.
///
/// Vendor, expert and admin are the same binary with different tabs (decision
/// D2), so this is one screen that reads the role rather than three near-copies.
/// None of them get a microphone — voice control is farmer-only by requirement,
/// and a mic here would advertise a capability the backend refuses.
class VendorShell extends ConsumerStatefulWidget {
  const VendorShell({super.key});

  @override
  ConsumerState<VendorShell> createState() => _VendorShellState();
}

class _VendorShellState extends ConsumerState<VendorShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: LoadingState(rows: 3));
    }

    final destinations = _destinationsFor(user.role, l);

    return Scaffold(
      backgroundColor: p.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: [
            for (var i = 0; i < destinations.length; i++)
              i == 0
                  ? _Dashboard(user: user)
                  : const ComingSoonState(),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: p.surface,
          border:
              Border(top: BorderSide(color: p.outline, width: p.borderWidth)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.activeIcon),
                label: d.label,
              ),
          ],
        ),
      ),
    );
  }

  List<({IconData icon, IconData activeIcon, String label})> _destinationsFor(
    Role role,
    AppL10n l,
  ) =>
      switch (role) {
        Role.vendor => [
            (
              icon: Icons.space_dashboard_outlined,
              activeIcon: Icons.space_dashboard_rounded,
              label: l.navDashboard,
            ),
            (
              icon: Icons.inventory_2_outlined,
              activeIcon: Icons.inventory_2_rounded,
              label: l.navProducts,
            ),
            (
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long_rounded,
              label: l.navOrders,
            ),
            (
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: l.navProfile,
            ),
          ],
        Role.expert => [
            (
              icon: Icons.fact_check_outlined,
              activeIcon: Icons.fact_check_rounded,
              label: l.navReviews,
            ),
            (
              icon: Icons.campaign_outlined,
              activeIcon: Icons.campaign_rounded,
              label: l.navNews,
            ),
            (
              icon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book_rounded,
              label: l.navKnowledge,
            ),
            (
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: l.navProfile,
            ),
          ],
        _ => [
            (
              icon: Icons.storefront_outlined,
              activeIcon: Icons.storefront_rounded,
              label: l.navVendors,
            ),
            (
              icon: Icons.people_outline_rounded,
              activeIcon: Icons.people_rounded,
              label: l.navUsers,
            ),
            (
              icon: Icons.rss_feed_outlined,
              activeIcon: Icons.rss_feed_rounded,
              label: l.navSources,
            ),
            (
              icon: Icons.article_outlined,
              activeIcon: Icons.article_rounded,
              label: l.navLogs,
            ),
          ],
      };
}

/// First tab for every non-farmer role: who you are and what needs attention.
///
/// The vendor's verification state is the headline because nothing else on this
/// screen is actionable until an admin has approved the shop (FR-22).
class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;

    final isVendor = user.role == Role.vendor;
    final verified = (user.vendor?.isVerified as bool?) ?? false;

    return ListView(
      padding: const EdgeInsets.all(Space.md),
      children: [
        Text(
          user.name as String,
          style: context.texts.titleLarge,
        ),
        const SizedBox(height: Space.xxs),
        Text(
          (user.role as Role) == Role.vendor
              ? (user.vendor?.shopName as String? ?? '')
              : (user.expert?.specialization as String? ?? ''),
          style: context.texts.bodySmall?.copyWith(color: p.onSurfaceMuted),
        ),
        const SizedBox(height: Space.lg),
        if (isVendor)
          AppCard(
            tint: verified ? p.primaryContainer : p.harvestContainer,
            child: Row(
              children: [
                Icon(
                  verified
                      ? Icons.verified_rounded
                      : Icons.hourglass_top_rounded,
                  color: verified ? p.onPrimaryContainer : p.onHarvestContainer,
                ),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        verified
                            ? l.vendorVerified
                            : l.vendorNotVerified,
                        style: context.texts.titleSmall?.copyWith(
                          color: verified
                              ? p.onPrimaryContainer
                              : p.onHarvestContainer,
                        ),
                      ),
                      Text(
                        l.pendingBody,
                        style: context.texts.bodySmall?.copyWith(
                          color: verified
                              ? p.onPrimaryContainer
                              : p.onHarvestContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: Space.lg),
        SectionHeader(
          title: l.comingSoon,
          icon: Icons.construction_rounded,
        ),
        const SizedBox(height: Space.md),
        const SizedBox(
          height: 320,
          child: ComingSoonState(),
        ),
      ],
    );
  }
}
