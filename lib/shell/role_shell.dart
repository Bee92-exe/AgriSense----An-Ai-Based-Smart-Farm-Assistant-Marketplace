import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/settings_provider.dart';
import '../core/theme/app_metrics.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/mic_fab.dart';
import '../core/widgets/states.dart';

/// One navigation destination in a role shell.
class ShellDestination {
  const ShellDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.builder,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final WidgetBuilder builder;
}

/// The chrome every signed-in role shares.
///
/// Four near-identical shell widgets were the alternative; one parameterised
/// shell means the tap-target floor, the nav label behaviour and the mic
/// placement are defined once. The farmer is the only role that gets
/// [showMic] — the PRD restricts voice control to farmers, and a mic on a vendor
/// screen would imply a capability that does not exist.
class RoleShell extends ConsumerStatefulWidget {
  const RoleShell({
    super.key,
    required this.destinations,
    this.initialIndex = 0,
    this.showMic = false,
    this.banner,
  });

  final List<ShellDestination> destinations;
  final int initialIndex;
  final bool showMic;

  /// Rendered above the body — used for the offline banner.
  final Widget? banner;

  @override
  ConsumerState<RoleShell> createState() => _RoleShellState();
}

class _RoleShellState extends ConsumerState<RoleShell> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.background,
      body: Column(
        children: [
          ?widget.banner,
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [
                for (final d in widget.destinations) d.builder(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: p.outline, width: p.borderWidth),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final d in widget.destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.activeIcon),
                label: d.label,
              ),
          ],
        ),
      ),
      floatingActionButton: widget.showMic
          ? Padding(
              // Clear of the navigation bar so the mic never overlaps a nav
              // label.
              padding: const EdgeInsets.only(bottom: 8),
              child: MicFab(
                onPressed: () => _showVoicePlaceholder(context),
                isEnabled: false,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Voice (build task F4) is not implemented yet. Rather than a mic that
  /// silently does nothing, it explains itself in Bangla — the design system's
  /// rule for an unavailable capability is an explanation plus the manual path,
  /// and touch is already fully working here.
  void _showVoicePlaceholder(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.md,
          0,
          Space.md,
          Space.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 220,
              child: ComingSoonState(),
            ),
            const SizedBox(height: Space.md),
            Text(
              ref.watch(settingsProvider).language == 'bn'
                  ? 'ভয়েস কমান্ড এখনো তৈরি হচ্ছে। আপাতত সব কাজ বোতাম দিয়েই করতে পারবেন।'
                  : 'Voice control is still being built. For now every task can be done with the buttons.',
              textAlign: TextAlign.center,
              style: context.texts.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
