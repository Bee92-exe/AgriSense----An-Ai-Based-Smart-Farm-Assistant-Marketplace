import 'package:flutter/material.dart';

/// Raw brand values. **Never read these from a widget** — read the semantic
/// roles on [AppPalette] instead, so the high-contrast theme can substitute
/// every one of them. These exist only to build the two palettes below.
///
/// The identity is **patachitra / alpona**: the palette of Bengali scroll
/// painting and floor art — indigo (নীল), turmeric (হলুদ), lac vermilion (লাক্ষা),
/// leaf green, peacock blue, on rice-paper white, drawn with chalk-black
/// outlines. That last part is structural, not decorative: outlines carry the
/// edge here instead of shadows, which is the same call sunlight mode makes, so
/// one widget set serves both themes.
abstract final class _Ink {
  const _Ink._();

  // Indigo. Only the rungs the two palettes actually consume live here — an
  // unused step on a colour scale is dead code that still has to be kept
  // contrast-correct.
  static const indigo700 = Color(0xFF21386B); // primary (11.40:1 with white)
  static const indigo900 = Color(0xFF16264A); // primaryDark, pressed states
  static const indigo100 = Color(0xFFDCE2F3); // primaryContainer
  static const indigoTint = Color(0xFF17203A); // onPrimaryContainer

  static const ink = Color(0xFF181713); // body text: 15.92:1 on rice paper
  static const inkMuted = Color(0xFF5B5344); // secondary text: 6.74:1
  static const chalk = Color(0xFFF7F1E3); // warm rice-paper background
  static const chalkSunken = Color(0xFFEFE6D2);
  static const chalkSurface = Color(0xFFFFFCF3); // cards
  static const rule = Color(0xFF2A2822); // the chalk-line outline

  // Turmeric / harvest gold. Always carries dark text — as a *text* colour on
  // paper it fails, which is why the palette exposes [goldInk] separately.
  static const gold500 = Color(0xFFE9A21A);
  static const goldContainer = Color(0xFFFBEBC7);
  static const goldInk = Color(0xFF5B3A00); // 8.69:1 on goldContainer
  static const ochre700 = Color(0xFF8A4B00); // turmeric that passes as text

  // Lac vermilion — reserved for anything the AI produced, so a farmer can see
  // at a glance which parts of the screen are a machine's guess. Kept lighter
  // and more orange than [crimson600] so an AI tag never reads as an error.
  static const vermilion600 = Color(0xFFB5341A);
  static const vermilionContainer = Color(0xFFFBE2D8);
  static const vermilionInk = Color(0xFF6E1F08);

  static const peacock600 = Color(0xFF12587A);
  static const peacockContainer = Color(0xFFD6EBF5);
  static const peacockInk = Color(0xFF0B3D57);

  static const roseContainer = Color(0xFFF7DDE4);
  static const roseInk = Color(0xFF6B1230);

  static const leafContainer = Color(0xFFE4F0E5);
  static const leafInk = Color(0xFF14472A);
  static const leaf600 = Color(0xFF2C6B3F); // success / verified / healthy

  static const crimson600 = Color(0xFFA31621);
  static const crimsonContainer = Color(0xFFF9DEDC);
  static const crimsonInk = Color(0xFF5F0F16);

  static const severityLowTint = Color(0xFFE4F0E5);
  static const severityHighContainer = Color(0xFFF8DED2);
  static const severityHigh = Color(0xFF9E3308);
  static const severityUrgent = Color(0xFF8A1220);
}

/// A paired tint used by the Home action tiles. Each tile gets its own hue so
/// the grid is scannable by colour *and* by icon *and* by its Bangla label.
@immutable
class ActionTint {
  const ActionTint({required this.background, required this.foreground});

  final Color background;
  final Color foreground;

  @override
  bool operator ==(Object other) =>
      other is ActionTint &&
      other.background == background &&
      other.foreground == foreground;

  @override
  int get hashCode => Object.hash(background, foreground);
}

/// Semantic colour roles. Every widget reads colours from here via
/// `context.palette`, so switching to high-contrast swaps the whole app at
/// once and no screen can hardcode a value by accident.
///
/// Contrast for every pairing below is asserted by
/// `test/theme_contrast_test.dart`. Change a value, run the test.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryDark,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.harvest,
    required this.onHarvest,
    required this.harvestContainer,
    required this.onHarvestContainer,
    required this.aiAccent,
    required this.onAiAccent,
    required this.aiContainer,
    required this.onAiContainer,
    required this.info,
    required this.onInfo,
    required this.success,
    required this.warning,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.surface,
    required this.surfaceSunken,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.outline,
    required this.borderWidth,
    required this.useShadow,
    required this.actionTints,
    required this.severityLow,
    required this.severityMedium,
    required this.severityHigh,
    required this.severityUrgent,
    required this.severityLowContainer,
    required this.severityMediumContainer,
    required this.severityHighContainer,
    required this.severityUrgentContainer,
    required this.confidenceHigh,
    required this.confidenceMedium,
    required this.confidenceLow,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryDark;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final Color harvest;
  final Color onHarvest;
  final Color harvestContainer;
  final Color onHarvestContainer;

  /// Marks AI-generated content. Always paired with an explicit "AI" tag, never
  /// used as the only signal.
  final Color aiAccent;
  final Color onAiAccent;
  final Color aiContainer;
  final Color onAiContainer;

  final Color info;
  final Color onInfo;
  final Color success;
  final Color warning;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;

  final Color background;
  final Color surface;
  final Color surfaceSunken;
  final Color onSurface;
  final Color onSurfaceMuted;

  /// The chalk line. In the light theme this is near-black rather than a grey
  /// hairline: the identity draws its edges, and a 1dp ink rule is the cheapest
  /// way to make a flat card read as a made object. High-contrast mode widens
  /// the same line to 2dp rather than choosing a different colour.
  final Color outline;

  /// 1.0 normally, 2.0 in high-contrast. Widgets that draw their own hairline
  /// must use this rather than a literal width.
  final double borderWidth;

  /// Unused by both shipped palettes — the identity is flat, and its own
  /// sunlight mode drops depth for a reason. Kept because the widgets that
  /// used to read it still branch on it, and a future theme may want it back.
  final bool useShadow;

  final List<ActionTint> actionTints;

  /// Chip *text* colours. These are darkened inks, not the decorative brand
  /// colours: turmeric and vermilion fail as text on their own tints, so the
  /// chips use these instead.
  final Color severityLow;
  final Color severityMedium;
  final Color severityHigh;
  final Color severityUrgent;

  final Color severityLowContainer;
  final Color severityMediumContainer;
  final Color severityHighContainer;
  final Color severityUrgentContainer;

  final Color confidenceHigh;
  final Color confidenceMedium;
  final Color confidenceLow;

  static const light = AppPalette(
    primary: _Ink.indigo700,
    onPrimary: Colors.white,
    primaryDark: _Ink.indigo900,
    primaryContainer: _Ink.indigo100,
    onPrimaryContainer: _Ink.indigoTint,
    harvest: _Ink.gold500,
    onHarvest: _Ink.ink,
    harvestContainer: _Ink.goldContainer,
    onHarvestContainer: _Ink.goldInk,
    aiAccent: _Ink.vermilion600,
    onAiAccent: Colors.white,
    aiContainer: _Ink.vermilionContainer,
    onAiContainer: _Ink.vermilionInk,
    info: _Ink.peacock600,
    onInfo: Colors.white,
    success: _Ink.leaf600,
    warning: _Ink.ochre700,
    error: _Ink.crimson600,
    onError: Colors.white,
    errorContainer: _Ink.crimsonContainer,
    onErrorContainer: _Ink.crimsonInk,
    background: _Ink.chalk,
    surface: _Ink.chalkSurface,
    surfaceSunken: _Ink.chalkSunken,
    onSurface: _Ink.ink,
    onSurfaceMuted: _Ink.inkMuted,
    outline: _Ink.rule,
    borderWidth: 1,
    useShadow: false,
    actionTints: [
      ActionTint(background: _Ink.indigo100, foreground: _Ink.indigoTint),
      ActionTint(background: _Ink.vermilionContainer, foreground: _Ink.vermilionInk),
      ActionTint(background: _Ink.goldContainer, foreground: _Ink.goldInk),
      ActionTint(background: _Ink.peacockContainer, foreground: _Ink.peacockInk),
      ActionTint(background: _Ink.roseContainer, foreground: _Ink.roseInk),
      ActionTint(background: _Ink.leafContainer, foreground: _Ink.leafInk),
    ],
    severityLow: _Ink.leaf600,
    severityMedium: _Ink.goldInk,
    severityHigh: _Ink.severityHigh,
    severityUrgent: _Ink.severityUrgent,
    severityLowContainer: _Ink.severityLowTint,
    severityMediumContainer: _Ink.goldContainer,
    severityHighContainer: _Ink.severityHighContainer,
    severityUrgentContainer: _Ink.crimsonContainer,
    confidenceHigh: _Ink.leaf600,
    confidenceMedium: _Ink.ochre700,
    confidenceLow: _Ink.crimson600,
  );

  /// Sunlight mode. Pure black on pure white, saturated fills, 2dp black
  /// borders on everything, and zero reliance on shadows or subtle tints.
  static const highContrast = AppPalette(
    primary: Color(0xFF0A3D1E),
    onPrimary: Colors.white,
    primaryDark: Color(0xFF062812),
    primaryContainer: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFF000000),
    harvest: Color(0xFFFFD600),
    onHarvest: Color(0xFF000000),
    harvestContainer: Color(0xFFFFD600),
    onHarvestContainer: Color(0xFF000000),
    // #9E3300 keeps white-on-clay at 7.17:1, clearing the sunlight target.
    aiAccent: Color(0xFF9E3300),
    onAiAccent: Colors.white,
    aiContainer: Color(0xFFFFE0CC),
    onAiContainer: Color(0xFF3A1000),
    info: Color(0xFF005B8C),
    onInfo: Colors.white,
    success: Color(0xFF0A3D1E),
    warning: Color(0xFF7A3800),
    error: Color(0xFFB00020),
    onError: Colors.white,
    errorContainer: Color(0xFFFFE0E0),
    onErrorContainer: Color(0xFF5A000C),
    background: Colors.white,
    surface: Colors.white,
    surfaceSunken: Colors.white,
    onSurface: Color(0xFF000000),
    onSurfaceMuted: Color(0xFF1A1A1A),
    outline: Color(0xFF000000),
    borderWidth: 2,
    useShadow: false,
    actionTints: [
      ActionTint(background: Color(0xFFFFFFFF), foreground: Color(0xFF000000)),
      ActionTint(background: Color(0xFFFFE0CC), foreground: Color(0xFF3A1000)),
      ActionTint(background: Color(0xFFFFD600), foreground: Color(0xFF000000)),
      ActionTint(background: Color(0xFFCCE9FF), foreground: Color(0xFF00263D)),
      ActionTint(background: Color(0xFFFFD9EC), foreground: Color(0xFF4A0026)),
      ActionTint(background: Color(0xFFCCF5EE), foreground: Color(0xFF00312C)),
    ],
    severityLow: Color(0xFF0A3D1E),
    severityMedium: _Ink.goldInk,
    severityHigh: Color(0xFF7A2600),
    severityUrgent: Color(0xFF8A0018),
    severityLowContainer: Color(0xFFFFFFFF),
    severityMediumContainer: Color(0xFFFFD600),
    severityHighContainer: Color(0xFFFFE0CC),
    severityUrgentContainer: Color(0xFFFFE0E0),
    confidenceHigh: Color(0xFF0A3D1E),
    confidenceMedium: Color(0xFF5A3200),
    confidenceLow: Color(0xFF8A0018),
  );

  /// Background for a severity chip given its text colour.
  Color severityContainer(Color severity) {
    if (severity == severityLow) return severityLowContainer;
    if (severity == severityMedium) return severityMediumContainer;
    if (severity == severityHigh) return severityHighContainer;
    return severityUrgentContainer;
  }

  @override
  AppPalette copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryDark,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? harvest,
    Color? onHarvest,
    Color? harvestContainer,
    Color? onHarvestContainer,
    Color? aiAccent,
    Color? onAiAccent,
    Color? aiContainer,
    Color? onAiContainer,
    Color? info,
    Color? onInfo,
    Color? success,
    Color? warning,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? background,
    Color? surface,
    Color? surfaceSunken,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? outline,
    double? borderWidth,
    bool? useShadow,
    List<ActionTint>? actionTints,
    Color? severityLow,
    Color? severityMedium,
    Color? severityHigh,
    Color? severityUrgent,
    Color? severityLowContainer,
    Color? severityMediumContainer,
    Color? severityHighContainer,
    Color? severityUrgentContainer,
    Color? confidenceHigh,
    Color? confidenceMedium,
    Color? confidenceLow,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      harvest: harvest ?? this.harvest,
      onHarvest: onHarvest ?? this.onHarvest,
      harvestContainer: harvestContainer ?? this.harvestContainer,
      onHarvestContainer: onHarvestContainer ?? this.onHarvestContainer,
      aiAccent: aiAccent ?? this.aiAccent,
      onAiAccent: onAiAccent ?? this.onAiAccent,
      aiContainer: aiContainer ?? this.aiContainer,
      onAiContainer: onAiContainer ?? this.onAiContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      outline: outline ?? this.outline,
      borderWidth: borderWidth ?? this.borderWidth,
      useShadow: useShadow ?? this.useShadow,
      actionTints: actionTints ?? this.actionTints,
      severityLow: severityLow ?? this.severityLow,
      severityMedium: severityMedium ?? this.severityMedium,
      severityHigh: severityHigh ?? this.severityHigh,
      severityUrgent: severityUrgent ?? this.severityUrgent,
      severityLowContainer: severityLowContainer ?? this.severityLowContainer,
      severityMediumContainer:
          severityMediumContainer ?? this.severityMediumContainer,
      severityHighContainer:
          severityHighContainer ?? this.severityHighContainer,
      severityUrgentContainer:
          severityUrgentContainer ?? this.severityUrgentContainer,
      confidenceHigh: confidenceHigh ?? this.confidenceHigh,
      confidenceMedium: confidenceMedium ?? this.confidenceMedium,
      confidenceLow: confidenceLow ?? this.confidenceLow,
    );
  }

  /// Themes never cross-fade in this app, so a hard switch at the midpoint is
  /// correct and avoids muddy in-between colours that fail contrast.
  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}
