import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_metrics.dart';
import 'app_text_styles.dart';

/// Convenience accessors so screens read semantic tokens, never literals.
extension AppThemeContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;

  TextTheme get texts => Theme.of(this).textTheme;

  /// True when the sunlight/high-contrast theme is active. Screens use this to
  /// drop gradients and decorative translucency.
  bool get isHighContrast => palette.borderWidth > 1;
}

/// Builds the two themes the app ships with.
///
/// There is deliberately no dark theme: the design system asks for *sunlight*
/// readability, and a high-contrast light mode is the answer to glare. Inventing
/// a dark palette would be a third thing to keep contrast-correct for no
/// requirement.
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData light() => _build(AppPalette.light, Brightness.light);

  static ThemeData highContrast() =>
      _build(AppPalette.highContrast, Brightness.light);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.onPrimaryContainer,
      secondary: p.harvest,
      onSecondary: p.onHarvest,
      secondaryContainer: p.harvestContainer,
      onSecondaryContainer: p.onHarvestContainer,
      tertiary: p.aiAccent,
      onTertiary: p.onAiAccent,
      tertiaryContainer: p.aiContainer,
      onTertiaryContainer: p.onAiContainer,
      error: p.error,
      onError: p.onError,
      errorContainer: p.errorContainer,
      onErrorContainer: p.onErrorContainer,
      surface: p.surface,
      onSurface: p.onSurface,
      surfaceContainerLowest: p.surface,
      surfaceContainerLow: p.surface,
      surfaceContainer: p.surfaceSunken,
      surfaceContainerHigh: p.surfaceSunken,
      surfaceContainerHighest: p.surfaceSunken,
      onSurfaceVariant: p.onSurfaceMuted,
      outline: p.outline,
      outlineVariant: p.outline,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: p.onSurface,
      onInverseSurface: p.surface,
      inversePrimary: p.primaryContainer,
    );

    final borderSide = BorderSide(color: p.outline, width: p.borderWidth);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      fontFamily: AppText.fontFamily,
      textTheme: AppText.textTheme(p.onSurface, p.onSurfaceMuted),
      // Fixed density: a farmer's thumb does not benefit from a compact mode,
      // and shrinking here would break the 56dp floor.
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashFactory: InkSparkle.splashFactory,
      extensions: <ThemeExtension<dynamic>>[p],

      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: AppText.subtitle.copyWith(color: p.onSurface),
        iconTheme: IconThemeData(color: p.onSurface, size: Sizes.iconInline),
      ),

      cardTheme: CardThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.cardAll,
          side: borderSide,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          disabledBackgroundColor: p.outline,
          disabledForegroundColor: p.surface,
          minimumSize: const Size.fromHeight(Sizes.primaryButtonHeight),
          elevation: 0,
          shape: const StadiumBorder(side: BorderSide.none),
          textStyle: AppText.label,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          minimumSize: const Size.fromHeight(Sizes.secondaryButtonHeight),
          side: BorderSide(color: p.primary, width: p.borderWidth),
          shape: const StadiumBorder(),
          textStyle: AppText.label,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.primary,
          minimumSize: const Size(Sizes.minTapTarget, Sizes.minTapTarget),
          textStyle: AppText.label,
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: p.onSurface,
          minimumSize: const Size(Sizes.minTapTarget, Sizes.minTapTarget),
          iconSize: Sizes.iconInline,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.aiAccent,
        foregroundColor: p.onAiAccent,
        elevation: 0,
        shape: const CircleBorder(),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.sm,
        ),
        hintStyle: AppText.body.copyWith(color: p.onSurfaceMuted),
        labelStyle: AppText.label.copyWith(color: p.onSurfaceMuted),
        floatingLabelStyle: AppText.label.copyWith(color: p.primary),
        helperStyle: AppText.caption.copyWith(color: p.onSurfaceMuted),
        errorStyle: AppText.caption.copyWith(color: p.error),
        border: OutlineInputBorder(
          borderRadius: Radii.fieldAll,
          borderSide: borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.fieldAll,
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.fieldAll,
          borderSide: BorderSide(color: p.primary, width: p.borderWidth + 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.fieldAll,
          borderSide: BorderSide(color: p.error, width: p.borderWidth + 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radii.fieldAll,
          borderSide: BorderSide(color: p.error, width: p.borderWidth + 1),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: p.outline,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheet),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.cardAll,
          side: borderSide,
        ),
        titleTextStyle: AppText.subtitle.copyWith(color: p.onSurface),
        contentTextStyle: AppText.body.copyWith(color: p.onSurface),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: p.primaryContainer,
        elevation: 0,
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppText.labelDense.copyWith(
            color: states.contains(WidgetState.selected)
                ? p.primary
                : p.onSurfaceMuted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 28,
            color: states.contains(WidgetState.selected)
                ? p.primary
                : p.onSurfaceMuted,
          ),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: p.outline,
        thickness: p.borderWidth,
        space: Space.lg,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.onSurface,
        contentTextStyle: AppText.body.copyWith(color: p.surface),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: Radii.cardAll),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        selectedColor: p.primaryContainer,
        side: borderSide,
        labelStyle: AppText.labelDense.copyWith(color: p.onSurface),
        secondaryLabelStyle: AppText.labelDense.copyWith(
          color: p.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Space.sm,
          vertical: Space.xs,
        ),
        shape: const StadiumBorder(),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primary,
        linearTrackColor: p.surfaceSunken,
        circularTrackColor: p.surfaceSunken,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? p.onPrimary
              : p.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? p.primary
              : p.surfaceSunken,
        ),
        trackOutlineColor: WidgetStateProperty.all(p.outline),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: p.onSurfaceMuted,
        textColor: p.onSurface,
        minVerticalPadding: Space.sm,
        shape: const RoundedRectangleBorder(borderRadius: Radii.cardAll),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: p.onSurface,
          borderRadius: Radii.cardAll,
        ),
        textStyle: AppText.caption.copyWith(color: p.surface),
      ),
    );
  }
}
