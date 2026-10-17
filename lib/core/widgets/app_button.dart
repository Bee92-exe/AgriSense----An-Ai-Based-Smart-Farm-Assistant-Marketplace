import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_theme.dart';

enum AppButtonTone { primary, secondary, danger, quiet }

/// The app's button.
///
/// Always full width and at least 64dp tall for the primary action, because the
/// design system's floor for a control a farmer taps outdoors is well above
/// Material's default. Every state is designed: loading shows a spinner in place
/// of the label so the layout never jumps, and disabled dims the fill rather
/// than hiding the button (a vanished button is a dead end).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.tone = AppButtonTone.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonTone tone;
  final bool isLoading;
  final bool isEnabled;

  /// When false the button hugs its content — for a pair of actions side by side.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = isEnabled && !isLoading;

    final (background, foreground, border) = switch (tone) {
      AppButtonTone.primary => (p.primary, p.onPrimary, null),
      AppButtonTone.secondary => (p.surface, p.primary, p.primary),
      AppButtonTone.danger => (p.error, p.onError, null),
      AppButtonTone.quiet => (p.surface, p.onSurface, p.outline),
    };

    final height = tone == AppButtonTone.primary
        ? Sizes.primaryButtonHeight
        : Sizes.secondaryButtonHeight;

    final child = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: Sizes.iconInline, color: foreground),
                const SizedBox(width: Space.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.labelLarge?.copyWith(color: foreground),
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      // The spinner replaces the label, so it must not be read as the label.
      excludeSemantics: true,
      child: SizedBox(
        width: expand ? double.infinity : null,
        height: height,
        child: FilledButton(
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            disabledBackgroundColor: p.outline,
            disabledForegroundColor: p.surfaceSunken,
            minimumSize: Size(expand ? double.infinity : 0, height),
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            elevation: 0,
            shape: StadiumBorder(
              side: border == null
                  ? BorderSide.none
                  : BorderSide(color: border, width: p.borderWidth),
            ),
            textStyle: context.texts.labelLarge,
          ),
          child: child,
        ),
      ),
    );
  }
}
