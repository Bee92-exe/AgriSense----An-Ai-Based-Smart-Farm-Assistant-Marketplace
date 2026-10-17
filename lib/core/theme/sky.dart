import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The time-of-day mood the Home hero paints itself in.
///
/// Deliberately separate from [AppPalette]: the palette is the app's *surface*
/// system and must stay constant, while the sky is the one place where colour
/// follows the real world. Keeping it in its own small model means the gradient
/// rules are testable without a widget, which is how the contrast guarantee in
/// `test/theme_contrast_test.dart` is enforced.
enum SkyMood { dawn, day, dusk, night, rain }

/// A two-stop sky plus the ink that is guaranteed legible on both stops.
///
/// Every value here is a deep tone rather than a pastel: the hero carries the
/// greeting, the temperature and the primary action, so its background has to
/// hold white text at 4.5:1 at *both* ends of the gradient, not just the middle.
@immutable
class SkyGradient {
  const SkyGradient({
    required this.mood,
    required this.top,
    required this.bottom,
    required this.ink,
  });

  final SkyMood mood;
  final Color top;
  final Color bottom;

  /// The text/icon colour for this sky.
  final Color ink;

  /// A single flat colour for sunlight mode, where a gradient is the first
  /// thing to disappear under glare.
  Color get flat => top;
}

/// Chooses the sky for a moment and a forecast icon.
///
/// The rain mood outranks the clock: a farmer opening the app at 2pm in a
/// downpour should see a rain sky, not a bright afternoon one. High contrast
/// returns the flat sunlight panel, because the whole point of that mode is to
/// remove gradient and translucency.
SkyGradient skyFor({
  required DateTime now,
  String? iconCode,
  bool highContrast = false,
}) {
  if (highContrast) {
    return const SkyGradient(
      mood: SkyMood.day,
      top: Color(0xFF0A3D1E),
      bottom: Color(0xFF0A3D1E),
      ink: Color(0xFFFFFFFF),
    );
  }

  if (iconCode == 'rainy') {
    return const SkyGradient(
      mood: SkyMood.rain,
      top: Color(0xFF16263C),
      bottom: Color(0xFF2C4A5E),
      ink: Color(0xFFFFFFFF),
    );
  }

  final hour = now.hour;
  if (hour >= 5 && hour < 8) {
    return const SkyGradient(
      mood: SkyMood.dawn,
      top: Color(0xFF5E230F),
      bottom: Color(0xFF9E3A1B),
      ink: Color(0xFFFFF6E8),
    );
  }
  if (hour >= 8 && hour < 16) {
    return const SkyGradient(
      mood: SkyMood.day,
      top: Color(0xFF21386B),
      bottom: Color(0xFF12587A),
      ink: Color(0xFFFFFFFF),
    );
  }
  if (hour >= 16 && hour < 19) {
    return const SkyGradient(
      mood: SkyMood.dusk,
      top: Color(0xFF12587A),
      bottom: Color(0xFF8C3318),
      ink: Color(0xFFFFF6E8),
    );
  }
  return const SkyGradient(
    mood: SkyMood.night,
    top: Color(0xFF0D1830),
    bottom: Color(0xFF21386B),
    ink: Color(0xFFFFFFFF),
  );
}
