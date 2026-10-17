import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_metrics.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/mic_fab.dart';
import '../l10n/app_localizations.dart';

/// The four farmer destinations, in the order the design system fixes them.
enum FarmerTab {
  home(Routes.home, Icons.home_outlined, Icons.home_rounded),
  market(Routes.market, Icons.storefront_outlined, Icons.storefront_rounded),
  history(Routes.history, Icons.history_outlined, Icons.history_rounded),
  profile(Routes.profile, Icons.person_outline_rounded, Icons.person_rounded);

  const FarmerTab(this.route, this.icon, this.activeIcon);

  final String route;
  final IconData icon;
  final IconData activeIcon;
}

/// Bottom navigation for the farmer shell.
///
/// Modelled as a widget the four tab screens each embed, rather than one
/// go_router `StatefulShellRoute`: every tab then stays an ordinary, directly
/// linkable route (which is what a push notification needs), and there is still
/// exactly one implementation of the bar.
class FarmerNav extends StatelessWidget {
  const FarmerNav({super.key, required this.current});

  final FarmerTab current;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;

    String labelFor(FarmerTab tab) => switch (tab) {
          FarmerTab.home => l.navHome,
          FarmerTab.market => l.navMarket,
          FarmerTab.history => l.navHistory,
          FarmerTab.profile => l.navProfile,
        };

    // A plain, fixed bar. An earlier revision made it translucent so the page
    // showed through it; on a phone that reads as a broken, half-painted bar
    // and the farmer asked for it to be solid again. The page still ends above
    // it (see AppScreen's bottom padding) so nothing is ever hidden behind it.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(top: BorderSide(color: p.outline, width: p.borderWidth)),
      ),
      child: NavigationBar(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        selectedIndex: FarmerTab.values.indexOf(current),
        onDestinationSelected: (i) {
          final tab = FarmerTab.values[i];
          if (tab != current) context.go(tab.route);
        },
        destinations: [
          for (final tab in FarmerTab.values)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.activeIcon),
              label: labelFor(tab),
            ),
        ],
      ),
    );
  }
}

/// The global microphone, docked centre above the nav.
///
/// Present on every farmer screen by requirement (FR-29) and on no other role.
class FarmerMicFab extends ConsumerWidget {
  const FarmerMicFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final p = context.palette;

    return MicFab(
      // Voice control is build task F4 and is not implemented. The button is
      // shown disabled with an explanation instead of pretending to listen,
      // because a mic that appears to work and does nothing is worse than one
      // that says it is not ready.
      isEnabled: false,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.md,
              0,
              Space.md,
              Space.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mic_off_rounded, size: 44, color: p.onSurfaceMuted),
                const SizedBox(height: Space.sm),
                Text(
                  Localizations.localeOf(context).languageCode == 'bn'
                      ? 'ভয়েস কমান্ড এখনো তৈরি হচ্ছে। সব কাজ বোতাম দিয়েই করতে পারবেন।'
                      : 'Voice control is still being built. Every task can be done with the buttons for now.',
                  textAlign: TextAlign.center,
                  style: context.texts.bodyMedium,
                ),
                const SizedBox(height: Space.md),
                Text(
                  l.voiceMicLabel,
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
