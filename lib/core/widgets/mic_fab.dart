import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_metrics.dart';
import '../theme/app_theme.dart';

/// The global mic for the farmer shell.
///
/// Sits above the bottom nav, centred, and is *always* the same widget in the
/// same place — the design system forbids per-screen microphones, and the SRS
/// requires voice on every farmer screen. It carries a visible Bangla label in
/// the semantics tree and a small "AI" dot in the paint, because a bare
/// microphone reads as "record" rather than "control the app".
class MicFab extends StatefulWidget {
  const MicFab({
    super.key,
    required this.onPressed,
    this.isListening = false,
    this.isEnabled = true,
  });

  final VoidCallback onPressed;

  /// Drives the pulse ring. While listening the button takes the AI accent so
  /// the state change is visible at a glance, not only audible.
  final bool isListening;

  /// Offline disables voice, but touch must keep working — so the button stays
  /// visible and explains itself on tap instead of disappearing.
  final bool isEnabled;

  @override
  State<MicFab> createState() => _MicFabState();
}

class _MicFabState extends State<MicFab> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Motion.pulse,
  );

  @override
  void initState() {
    super.initState();
    if (widget.isListening) _c.repeat();
  }

  @override
  void didUpdateWidget(MicFab old) {
    super.didUpdateWidget(old);
    if (widget.isListening && !_c.isAnimating) {
      _c.repeat();
    } else if (!widget.isListening && _c.isAnimating) {
      _c.stop();
      _c.value = 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);
    final reduced = MediaQuery.disableAnimationsOf(context);

    final fill = widget.isEnabled
        ? (widget.isListening ? p.primaryDark : p.aiAccent)
        : p.outline;
    final foreground = widget.isEnabled ? p.onAiAccent : p.surface;

    return Semantics(
      button: true,
      enabled: widget.isEnabled,
      liveRegion: widget.isListening,
      label: widget.isEnabled ? l.voiceMicLabel : l.voiceNoInternet,
      child: SizedBox(
        width: Sizes.micFab + 24,
        height: Sizes.micFab + 24,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isListening && !reduced)
              AnimatedBuilder(
                animation: _c,
                builder: (context, _) => Container(
                  width: Sizes.micFab + 24 * _c.value,
                  height: Sizes.micFab + 24 * _c.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fill.withValues(alpha: 0.28 * (1 - _c.value)),
                  ),
                ),
              ),
            SizedBox(
              width: Sizes.micFab,
              height: Sizes.micFab,
              child: Material(
                color: fill,
                shape: CircleBorder(
                  side: BorderSide(
                    color: p.outline,
                    width: p.borderWidth,
                  ),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onPressed,
                  child: Icon(
                    widget.isListening
                        ? Icons.graphic_eq_rounded
                        : Icons.mic_rounded,
                    size: 34,
                    color: foreground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
