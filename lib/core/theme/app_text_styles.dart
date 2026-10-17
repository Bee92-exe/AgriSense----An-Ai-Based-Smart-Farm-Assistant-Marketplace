import 'package:flutter/material.dart';

/// The Bangla-first type scale.
///
/// Sizes come straight from the design system and are a floor, not a target:
/// body text is 18 and nothing user-facing may go below 16. Bangla needs the
/// generous line heights here or conjuncts and reph collide between lines.
abstract final class AppText {
  const AppText._();

  static const String fontFamily = 'HindSiliguri';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  /// Bunched-up variant for dense role shells (vendor/expert/admin) where rows
  /// must stay >= 16sp but can publish fewer lines.
  static const TextStyle bodyDense = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle labelDense = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Only for the numeric readout inside the confidence gauge, where the glyphs
  /// are digits and a fixed box must not reflow.
  static const TextStyle metric = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  /// Builds the Material [TextTheme] so default widget text (dialogs, list
  /// tiles, tooltips) inherits the Bangla family and never falls back to
  /// Roboto's Latin-only metrics.
  static TextTheme textTheme(Color onSurface, Color onSurfaceMuted) {
    final base = ThemeData.light().textTheme;
    return base.copyWith(
      displayLarge: display.copyWith(color: onSurface),
      displayMedium: display.copyWith(color: onSurface),
      displaySmall: title.copyWith(color: onSurface),
      headlineLarge: title.copyWith(color: onSurface),
      headlineMedium: title.copyWith(color: onSurface),
      headlineSmall: subtitle.copyWith(color: onSurface),
      titleLarge: subtitle.copyWith(color: onSurface),
      titleMedium: label.copyWith(color: onSurface),
      titleSmall: labelDense.copyWith(color: onSurface),
      bodyLarge: body.copyWith(color: onSurface),
      bodyMedium: bodyDense.copyWith(color: onSurface),
      bodySmall: caption.copyWith(color: onSurfaceMuted),
      labelLarge: label.copyWith(color: onSurface),
      labelMedium: labelDense.copyWith(color: onSurface),
      labelSmall: caption.copyWith(color: onSurfaceMuted),
    );
  }
}
