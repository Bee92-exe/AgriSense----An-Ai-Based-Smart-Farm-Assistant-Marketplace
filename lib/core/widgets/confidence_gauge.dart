import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_metrics.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/labels.dart';

/// The headline read-out on a diagnosis result.
///
/// A number alone ("0.91") means nothing to most farmers and a colour alone is
/// inaccessible, so the gauge carries all three signals at once: the arc length
/// and colour, the percentage in Bangla digits, and the level in words with its
/// own icon. The visible band boundaries (0.70 / 0.85) are drawn as ticks, which
/// is what makes "somewhat confident" legible as a position rather than a mood.
class ConfidenceGauge extends StatelessWidget {
  const ConfidenceGauge({
    super.key,
    required this.score,
    this.level,
    this.size = 200,
  });

  final double score;
  final ConfidenceLevel? level;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);
    final f = AppFormat.of(context);
    final lvl = level ?? ConfidenceLevel.fromScore(score);
    final color = switch (lvl) {
      ConfidenceLevel.high => p.confidenceHigh,
      ConfidenceLevel.medium => p.confidenceMedium,
      ConfidenceLevel.low => p.confidenceLow,
    };

    return Semantics(
      label: '${l.diagnosisConfidenceLabel}: '
          '${f.percentFromFraction(score)} — ${lvl.label(l)}',
      child: SizedBox(
        width: size,
        // The bowl is a true semicircle (height = size / 2); the extra 12% below
        // it is where the level words sit. Squashing the painters into a
        // shallower box made the arc elliptical and threw the threshold ticks
        // off the stroke entirely.
        height: size * 0.62,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: score.clamp(0.0, 1.0)),
          duration: Motion.duration(context, const Duration(milliseconds: 700)),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Stack(
            children: [
              CustomPaint(
                size: Size(size, size / 2),
                painter: _GaugePainter(
                  value: value,
                  color: color,
                  trackColor: p.surfaceSunken,
                  // Ghosted in the colour theme: the ticks mark the 0.70 / 0.85
                  // safety boundaries, not part of the reading itself. Sunlight
                  // mode keeps them solid, because there faint marks vanish.
                  tickColor: p.borderWidth > 1
                      ? p.outline
                      : p.outline.withValues(alpha: 0.4),
                  strokeWidth: 18,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        f.percentFromFraction(value),
                        style: context.texts.displayLarge
                            ?.copyWith(color: color, fontSize: 38, height: 1.1),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(lvl.icon, size: 16, color: color),
                          const SizedBox(width: 4),
                          // The gauge is a fixed-size dial and the level word is
                          // long in Bangla; without a flex the label is painted
                          // outside the dial at the larger text scales.
                          Flexible(
                            child: Text(
                              lvl.label(l),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.texts.labelSmall
                                  ?.copyWith(color: color),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.tickColor,
    required this.strokeWidth,
  });

  final double value;
  final Color color;
  final Color trackColor;
  final Color tickColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2 - strokeWidth / 2;
    final centre = Offset(size.width / 2, size.height);
    final rect = Rect.fromCircle(center: centre, radius: radius);
    const start = math.pi;
    const sweep = math.pi;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, start, sweep, false, track);

    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (value > 0) {
      canvas.drawArc(rect, start, sweep * value, false, progress);
    }

    // Marks for the 0.70 and 0.85 safety thresholds, so the bands are visible
    // rather than something the user has to be told. They cross the stroke
    // rather than floating near it, which is why they are drawn at radius ± half
    // the stroke width around the arc's own centre line.
    final tick = Paint()
      ..color = tickColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (final boundary in const [
      ConfidenceLevel.lowThreshold,
      ConfidenceLevel.highThreshold,
    ]) {
      final angle = start + sweep * boundary;
      final outer = radius + strokeWidth / 2 + 2;
      final inner = radius - strokeWidth / 2 - 2;
      canvas.drawLine(
        Offset(
          centre.dx + outer * math.cos(angle),
          centre.dy + outer * math.sin(angle),
        ),
        Offset(
          centre.dx + inner * math.cos(angle),
          centre.dy + inner * math.sin(angle),
        ),
        tick,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.color != color;
}
