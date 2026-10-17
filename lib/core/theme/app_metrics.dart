import 'package:flutter/widgets.dart';

/// Spacing, shape and motion constants. An 8pt grid with a 4pt half-step, per
/// the design system. Widgets must not invent their own numbers.
abstract final class Space {
  const Space._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Screen edge padding. 16 everywhere per the design system.
  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: md);

  /// Minimum gap between two separate tap targets.
  static const double minTapGap = 12;
}

/// Corner radii. Cards 16, buttons pill, sheets 24 on the top corners only.
abstract final class Radii {
  const Radii._();

  static const Radius card = Radius.circular(16);
  static const Radius tile = Radius.circular(20);
  static const Radius chip = Radius.circular(999);
  static const Radius field = Radius.circular(14);

  /// The header band is the one oversized shape in the app — it is the screen's
  /// painted panel, not a card.
  static const Radius band = Radius.circular(28);

  static const BorderRadius cardAll = BorderRadius.all(card);
  static const BorderRadius tileAll = BorderRadius.all(tile);
  static const BorderRadius chipAll = BorderRadius.all(chip);
  static const BorderRadius fieldAll = BorderRadius.all(field);
  static const BorderRadius bandAll = BorderRadius.all(band);

  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(24),
  );
}

/// Fixed sizes that exist because of accessibility rules, not taste.
abstract final class Sizes {
  const Sizes._();

  /// Hard floor for anything a finger has to hit.
  static const double minTapTarget = 56;

  /// Primary buttons are deliberately taller than the floor.
  static const double primaryButtonHeight = 64;
  static const double secondaryButtonHeight = 56;

  static const double micFab = 72;
  static const double iconTile = 32;
  static const double iconInline = 24;
  static const double iconLarge = 48;

  /// Circular "plate" behind a glyph — the app's stand-in for illustration.
  static const double medallion = 56;
  static const double medallionLarge = 68;

  /// Home action tiles: 2-column grid, never shorter than this. Raised from
  /// 140 with the Living Field layout, so the watermark glyph has room to bleed
  /// off the corner without touching the hint text.
  static const double actionTileHeight = 152;

  static const double listThumbnail = 64;
  static const double avatar = 44;

  /// Skeleton/placeholder corner rounding for shimmer blocks.
  static const BorderRadius skeleton = BorderRadius.all(Radius.circular(12));
}

/// Motion. Short and purposeful; every animated widget must consult
/// [Motion.duration] so reduce-motion is honoured in one place.
abstract final class Motion {
  const Motion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 250);

  /// Pulse ring on the mic, and other decorative-only loops.
  static const Duration pulse = Duration(milliseconds: 1400);

  /// Returns [Duration.zero] when the platform asks for reduced motion.
  static Duration duration(BuildContext context, Duration requested) {
    return MediaQuery.disableAnimationsOf(context) ? Duration.zero : requested;
  }
}
