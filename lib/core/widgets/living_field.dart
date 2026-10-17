import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/sky.dart';

/// The Living Field hero.
///
/// One painted panel that behaves like the view out of a village door: a sky
/// whose colour follows the real weather and the real clock (see [skyFor]), the
/// alpona motif drifting behind the content, and a crop line along the bottom
/// edge that the sheet below slides over.
///
/// The ambience is **opt-in** — the অ্যানিমেশন mode. It follows the reference
/// the client liked: off by default, remembered on the device, and adding slow
/// decorative loops while the interface itself keeps its ordinary transitions.
/// It is dropped entirely in sunlight mode and under reduce-motion, and it is
/// never the carrier of meaning: the temperature, the condition and the warning
/// are text first, movement second.
///
/// Cost control is deliberate, because this is the app's most expensive surface:
/// a single [AnimationController] drives every layer through one [CustomPainter]
/// inside a [RepaintBoundary], particle counts are capped in the tens, and the
/// whole layer is skipped when the mode is off.
class LivingField extends StatefulWidget {
  const LivingField({
    super.key,
    required this.sky,
    required this.animated,
    required this.child,
    this.scrollOffset,
    this.cropHeight = 64,
  });

  final SkyGradient sky;

  /// True when the farmer has turned অ্যানিমেশন on.
  final bool animated;

  final Widget child;

  /// The page's scroll position, used for a slow parallax. Optional so the
  /// hero can be used on a screen that does not scroll.
  final ValueListenable<double>? scrollOffset;

  /// How much of the panel's bottom the crop silhouettes occupy. The content
  /// above them is padded by the same amount, so the two never collide.
  final double cropHeight;

  @override
  State<LivingField> createState() => _LivingFieldState();
}

class _LivingFieldState extends State<LivingField>
    with SingleTickerProviderStateMixin {
  /// 12 seconds per loop. The first version ran at 30s with amplitudes of a few
  /// pixels, which on a phone is indistinguishable from a still image — the
  /// client turned the mode on and reasonably reported that nothing moved.
  /// Slower than a cartoon, fast enough to read as living weather.
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncClock();
  }

  @override
  void didUpdateWidget(LivingField old) {
    super.didUpdateWidget(old);
    _syncClock();
  }

  /// Runs only when the mode is on, the platform allows animation, and the
  /// subtree is actually on screen — a paused [TickerMode] means the hero is
  /// behind another route.
  void _syncClock() {
    final wanted = widget.animated &&
        !MediaQuery.disableAnimationsOf(context) &&
        TickerMode.valuesOf(context).enabled;

    if (wanted && !_clock.isAnimating) {
      _clock.repeat();
    } else if (!wanted && _clock.isAnimating) {
      _clock.stop();
      _clock.value = 0;
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ambient = widget.animated &&
        !MediaQuery.disableAnimationsOf(context) &&
        TickerMode.valuesOf(context).enabled &&
        !context.isHighContrast;

    final scroll = widget.scrollOffset;

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _FieldPainter(
                sky: widget.sky,
                clock: _clock,
                scroll: scroll,
                ambient: ambient,
                flat: context.isHighContrast,
                accent: context.palette.harvest,
                cropHeight: widget.cropHeight,
              ),
              // Repaints come from the clock and the scroll notifier, never
              // from a widget rebuild.
              isComplex: true,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: widget.cropHeight),
          child: widget.child,
        ),
      ],
    );
  }
}

class _FieldPainter extends CustomPainter {
  _FieldPainter({
    required this.sky,
    required this.clock,
    required this.scroll,
    required this.ambient,
    required this.flat,
    required this.accent,
    required this.cropHeight,
  }) : super(repaint: Listenable.merge([clock, scroll]));

  final SkyGradient sky;
  final Animation<double> clock;
  final ValueListenable<double>? scroll;
  final bool ambient;
  final bool flat;
  final Color accent;
  final double cropHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock.value;
    final drift = (scroll?.value ?? 0) * 0.05;

    _paintSky(canvas, size, t);
    if (!flat) {
      _paintBody(canvas, size, t);
      if (ambient) _paintClouds(canvas, size, t);
      _paintMotif(canvas, size, t, drift);
      if (ambient) _paintWeather(canvas, size, t);
    }
    _paintCrops(canvas, size, t);
  }

  void _paintSky(Canvas canvas, Size size, double t) {
    final rect = Offset.zero & size;
    if (flat) {
      canvas.drawRect(rect, Paint()..color = sky.flat);
      return;
    }
    // The gradient breathes: two degrees of angle over the loop is enough for
    // the light to feel alive without the panel ever looking like it is
    // flickering.
    final sway = ambient ? math.sin(t * 2 * math.pi) * 0.08 : 0.0;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment(-0.35 + sway, -1),
          end: Alignment(0.35 + sway, 1),
          colors: [sky.top, sky.bottom],
        ).createShader(rect),
    );
  }

  /// The sun or moon disc. A soft sheen, not a shape to look at.
  void _paintBody(Canvas canvas, Size size, double t) {
    final night = sky.mood == SkyMood.night;
    // Sits low enough to clear the two mode toggles the hero puts in its own
    // top-right corner, and left of the greeting's text column.
    final centre = Offset(size.width * 0.70, size.height * 0.27);
    final pulse = ambient ? 1 + 0.04 * math.sin(t * 2 * math.pi * 2) : 1.0;
    final radius = size.width * 0.105 * pulse;

    canvas.drawCircle(
      centre,
      radius * 1.9,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accent.withValues(alpha: night ? 0.16 : 0.26),
            accent.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: centre, radius: radius * 1.9)),
    );
    final disc = Paint()..color = accent.withValues(alpha: ambient ? 0.5 : 0.42);

    // The moon wears a crescent bite; the sun does not. The bite is a path
    // subtraction rather than a `dstOut` blend, because a blend would also
    // erase the sky beneath it.
    if (!night) {
      canvas.drawCircle(centre, radius, disc);
      return;
    }

    final full = Path()
      ..addOval(Rect.fromCircle(center: centre, radius: radius));
    final bite = Path()
      ..addOval(
        Rect.fromCircle(
          center: centre.translate(radius * 0.42, -radius * 0.2),
          radius: radius * 0.86,
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, full, bite),
      disc,
    );
  }

  /// Long, soft cloud bands crossing the sky. Two layers at different speeds
  /// give the panel depth without a single particle being drawn.
  void _paintClouds(Canvas canvas, Size size, double t) {
    final paint = Paint()
      ..color = sky.ink.withValues(alpha: 0.055);
    final bright = Paint()
      ..color = accent.withValues(alpha: 0.07);

    for (var i = 0; i < 4; i++) {
      final speed = 0.16 + i * 0.07;
      final x = ((i * 0.37 + t * speed) % 1.35 - 0.18) * size.width;
      final y = size.height * (0.12 + i * 0.14);
      final w = size.width * (0.34 + (i % 2) * 0.16);
      final h = 18.0 + (i % 3) * 6;

      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: w, height: h),
        i.isEven ? paint : bright,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x + w * 0.18, y - h * 0.45),
          width: w * 0.46,
          height: h * 1.1,
        ),
        i.isEven ? paint : bright,
      );
    }
  }

  /// The fish-scale motif, drawn faintly and drifting sideways. It is texture
  /// behind text; if it ever competes with a label it has stopped working.
  void _paintMotif(Canvas canvas, Size size, double t, double drift) {
    const unitW = 64.0;
    const unitH = 32.0;
    final rows = (size.height / unitH).ceil() + 1;
    final cols = (size.width / unitW).ceil() + 3;
    final offsetX = -drift - (ambient ? t * unitW * 1.6 : 0);
    final breathe = ambient ? 0.10 + 0.03 * math.sin(t * 2 * math.pi) : 0.13;

    final stroke = Paint()
      ..color = sky.ink.withValues(alpha: breathe)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final dot = Paint()..color = accent.withValues(alpha: ambient ? 0.22 : 0.16);

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    for (var row = 0; row < rows; row++) {
      final y = row * unitH;
      final xShift = row.isEven ? 0.0 : unitW / 2;
      for (var col = 0; col < cols; col++) {
        final x = col * unitW + xShift + (offsetX % unitW);
        canvas.drawArc(
          Rect.fromCircle(center: Offset(x, y + unitH), radius: unitW / 2),
          math.pi,
          math.pi,
          false,
          stroke,
        );
        canvas.drawCircle(Offset(x, y + 5), 2, dot);
      }
    }
    canvas.restore();
  }

  /// Rain, motes or stars — whichever the current sky implies.
  void _paintWeather(Canvas canvas, Size size, double t) {
    if (sky.mood == SkyMood.rain) {
      final rain = Paint()
        ..color = sky.ink.withValues(alpha: 0.3)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < 26; i++) {
        final x = ((i * 0.618) % 1) * size.width;
        final speed = 0.9 + (i % 5) * 0.18;
        final y = ((t * speed * 2 + i * 0.37) % 1) * (size.height * 1.05);
        canvas.drawLine(Offset(x, y), Offset(x - 3, y + 14), rain);
      }
      return;
    }

    if (sky.mood == SkyMood.night) {
      for (var i = 0; i < 26; i++) {
        final x = ((i * 0.618) % 1) * size.width;
        final y = ((i * 0.37) % 1) * size.height * 0.62;
        final twinkle = 0.2 + 0.6 * math.sin(t * 2 * math.pi * 2 + i * 1.7).abs();
        canvas.drawCircle(
          Offset(x, y),
          1.3 + twinkle,
          Paint()..color = sky.ink.withValues(alpha: 0.15 + twinkle * 0.55),
        );
      }
      // One shooting star per loop, so there is a moment worth watching for.
      final shot = (t * 2) % 1;
      if (shot < 0.22) {
        final p = shot / 0.22;
        final start = Offset(size.width * 0.18, size.height * 0.10);
        final pos = start + Offset(120, 54) * p;
        final tail = Paint()
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            colors: [
              sky.ink.withValues(alpha: 0),
              sky.ink.withValues(alpha: 0.7 * (1 - p)),
            ],
          ).createShader(Rect.fromPoints(pos - const Offset(26, 12), pos));
        canvas.drawLine(pos - const Offset(26, 12), pos, tail);
      }
      return;
    }

    // Dawn, day and dusk share one ambience: slow motes rising through the
    // panel, like dust in a shaft of light.
    for (var i = 0; i < 16; i++) {
      final phase = (t * 0.9 + i * 0.29) % 1;
      final x = ((i * 0.618) % 1) * size.width +
          math.sin((phase + i) * 2 * math.pi) * 12;
      final y = size.height * (1 - phase) * 0.9;
      canvas.drawCircle(
        Offset(x, y),
        1.6 + 1.4 * (1 - phase),
        Paint()..color = accent.withValues(alpha: 0.4 * (1 - phase) + 0.06),
      );
    }
  }

  /// The crop line: stalks along the bottom edge, swaying when the mode is on.
  /// This is what makes the panel read as a field rather than a gradient, and
  /// it is the layer the rice-paper sheet slides over.
  void _paintCrops(Canvas canvas, Size size, double t) {
    const spacing = 26.0;
    final count = (size.width / spacing).ceil() + 1;
    final baseY = size.height;
    final ink = sky.ink;

    final stalk = Paint()
      ..color = ink.withValues(alpha: 0.32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final head = Paint()..color = accent.withValues(alpha: 0.55);

    for (var i = 0; i < count; i++) {
      final x = i * spacing + (i.isEven ? 0 : spacing / 2);
      final tall = cropHeight * (0.62 + ((i * 7) % 5) * 0.09);
      // Each stalk has its own phase and a slower secondary sway, so the line
      // moves as a field rather than as one rigid comb.
      final sway = ambient
          ? math.sin(t * 2 * math.pi * 2 + i * 0.7) * 8 +
              math.sin(t * 2 * math.pi + i * 0.31) * 4
          : (i.isEven ? 2.0 : -1.6);

      final top = Offset(x + sway, baseY - tall);
      canvas.drawPath(
        Path()
          ..moveTo(x, baseY)
          ..quadraticBezierTo(x + sway * 0.4, baseY - tall * 0.55, top.dx, top.dy),
        stalk,
      );
      canvas.drawOval(
        Rect.fromCenter(center: top, width: 7, height: 13),
        head,
      );
    }
  }

  @override
  bool shouldRepaint(_FieldPainter old) =>
      old.sky != sky ||
      old.flat != flat ||
      old.ambient != ambient ||
      old.cropHeight != cropHeight;
}
