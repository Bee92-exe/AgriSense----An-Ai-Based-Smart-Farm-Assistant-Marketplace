import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_theme.dart';

/// The painted header band.
///
/// This is the app's one expressive surface. Everything below it stays plain on
/// purpose: patachitra is flat colour inside drawn outlines, so the identity
/// comes from a single painted panel per screen, not from ornament everywhere.
/// The band carries the motif (see [_AlponaPainter]) and, optionally, a
/// scalloped lower edge — the shape a painted wall panel has in a village house.
///
/// Both devices are skipped in sunlight mode. They are texture and a soft edge:
/// exactly the two things that vanish under glare and that the high-contrast
/// rules forbid relying on.
class AlponaBand extends StatelessWidget {
  const AlponaBand({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Space.md),
    this.scalloped = true,
    this.fill,
  });

  final Widget child;

  /// Generous by default: the band holds the greeting and the weather, and it
  /// also has to keep clear of the scallops at the bottom edge.
  final EdgeInsets padding;

  final bool scalloped;

  /// Overrides the page's primary indigo — the urgent-news banner and the
  /// vendor's verification panel each paint themselves a different colour.
  final Color? fill;

  /// Height of one scallop wave. The clipper needs the same value to cut the
  /// path, so it is defined once here.
  static const double _scallop = 16;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final flat = context.isHighContrast;
    final colour = fill ?? p.primary;
    final bottomPad = padding.bottom + (scalloped ? _scallop : 0);

    final band = DecoratedBox(
      decoration: BoxDecoration(
        color: colour,
        borderRadius: Radii.bandAll,
      ),
      child: Stack(
        children: [
          // Texture first, so it can never paint over a label.
          if (!flat)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: Radii.bandAll,
                child: CustomPaint(
                  painter: _AlponaPainter(
                    line: p.onPrimary.withValues(alpha: 0.22),
                    accent: p.harvest.withValues(alpha: 0.30),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              padding.top,
              padding.right,
              bottomPad,
            ),
            child: child,
          ),
        ],
      ),
    );

    if (!scalloped || flat) {
      // Sunlight mode keeps the panel but squares off the wave: a soft edge is
      // the first thing to disappear in glare, and drawing it anyway would only
      // make the layout harder to read.
      return band;
    }

    return ClipPath(
      clipper: _ScallopClipper(_scallop),
      child: band,
    );
  }
}

/// Draws the repeating motif that fills [AlponaBand].
///
/// One unit is a half-circle sitting on a baseline with a dot above it — the
/// "fish scale" row that runs along the edge of a painted scroll. Units are laid
/// out half-dropped so the rows interlock, and every second row's arc is filled
/// rather than stroked, which is what stops the result reading as a pattern
/// swatch. It is deliberately faint: texture behind text, never a competitor.
class _AlponaPainter extends CustomPainter {
  const _AlponaPainter({required this.line, required this.accent});

  final Color line;
  final Color accent;

  static const double _unitW = 52;
  static const double _unitH = 26;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final solid = Paint()..color = line;
    final dot = Paint()..color = accent;

    final rows = (size.height / _unitH).ceil() + 1;
    final cols = (size.width / _unitW).ceil() + 2;

    for (var row = 0; row < rows; row++) {
      final y = row * _unitH;
      final offset = row.isEven ? 0.0 : _unitW / 2;
      final filledRow = row % 3 == 1;

      for (var col = 0; col < cols; col++) {
        final x = col * _unitW + offset;
        final rect = Rect.fromCircle(
          center: Offset(x, y + _unitH),
          radius: _unitW / 2,
        );

        // The scale: a half-circle opening upward, with its inner echo.
        canvas.drawArc(rect, math.pi, math.pi, false, stroke);
        canvas.drawArc(
          Rect.fromCircle(center: Offset(x, y + _unitH), radius: _unitW / 2 - 7),
          math.pi,
          math.pi,
          false,
          stroke,
        );
        if (filledRow) {
          canvas.drawCircle(Offset(x, y + _unitH - 5), 2.4, solid);
        }
        canvas.drawCircle(Offset(x, y + 4), 2.2, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_AlponaPainter old) =>
      old.line != line || old.accent != accent;
}

/// Cuts the band's bottom edge into a row of half-circles.
class _ScallopClipper extends CustomClipper<Path> {
  const _ScallopClipper(this.depth);

  final double depth;

  @override
  Path getClip(Size size) {
    const r = Radii.band;
    final path = Path()
      ..moveTo(0, size.height - depth)
      ..lineTo(0, r.x)
      ..quadraticBezierTo(0, 0, r.x, 0)
      ..lineTo(size.width - r.x, 0)
      ..quadraticBezierTo(size.width, 0, size.width, r.x)
      ..lineTo(size.width, size.height - depth);

    // Half-circles of radius `depth / 2` marching back to the left. Cutting a
    // whole number of them and letting the last one overhang keeps the wave in
    // phase with the motif instead of squeezing it to fit.
    final wave = depth;
    final count = (size.width / wave).floor() + 1;
    for (var i = 0; i < count; i++) {
      final x = size.width - i * wave;
      path.arcToPoint(
        Offset(x - wave, size.height - depth),
        radius: Radius.circular(wave / 2),
        clockwise: true,
      );
    }

    path
      ..lineTo(0, size.height - depth)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(_ScallopClipper old) => old.depth != depth;
}

/// The app's stand-in for illustration: a circular painted plate carrying a
/// glyph, outlined in ink like everything else here.
///
/// Every action tile, list thumbnail and empty state uses one, which is what
/// keeps a screen full of icons feeling like one artefact rather than a pile of
/// unrelated Material widgets.
class Medallion extends StatelessWidget {
  const Medallion({
    super.key,
    required this.icon,
    this.size = Sizes.medallion,
    this.background,
    this.foreground,
    this.child,
  });

  final IconData icon;
  final double size;
  final Color? background;
  final Color? foreground;

  /// Replaces the glyph when the plate needs to hold, say, a count.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fg = foreground ?? p.primary;
    final bg = background ?? p.surfaceSunken;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: fg.withValues(alpha: 0.55), width: 1.5),
      ),
      child: child ??
          Icon(icon, size: size * 0.5, color: fg),
    );
  }
}

/// Section separator: a dashed seam with a diamond at its centre.
///
/// Replaces `Divider` wherever two groups of content are being separated rather
/// than two lines of one list — the stitch is a group boundary, which is what
/// the eye needs and a 1dp rule does not say.
class StitchDivider extends StatelessWidget {
  const StitchDivider({super.key, this.label});

  /// Optional word that sits in the seam, e.g. "অথবা".
  final String? label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ink = p.onSurfaceMuted.withValues(alpha: p.borderWidth > 1 ? 1 : 0.55);

    if (label != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Row(
          children: [
            Expanded(child: _DashedLine(colour: ink, flip: true)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.xs),
              child: Text(
                label!,
                style: context.texts.bodySmall?.copyWith(color: ink),
              ),
            ),
            Expanded(child: _DashedLine(colour: ink)),
          ],
        ),
      );
    }

    return Center(
      child: SizedBox(
        height: 12,
        width: 120,
        child: CustomPaint(
          painter: _StitchPainter(colour: ink),
          size: const Size(120, 12),
        ),
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.colour, this.flip = false});

  final Color colour;
  final bool flip;

  @override
  Widget build(BuildContext context) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(flip ? math.pi : 0),
        child: SizedBox(
          height: 1,
          child: CustomPaint(painter: _DashPainter(colour: colour)),
        ),
      );
}

class _DashPainter extends CustomPainter {
  const _DashPainter({required this.colour});

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (double x = 0; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, 0), Offset(x + 5, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.colour != colour;
}

class _StitchPainter extends CustomPainter {
  const _StitchPainter({required this.colour});

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final mid = size.height / 2;
    const half = 5.0;

    // Dashes up to the diamond, then away from it.
    for (double x = 0; x < size.width / 2 - half - 4; x += 9) {
      canvas.drawLine(Offset(x, mid), Offset(x + 5, mid), paint);
      canvas.drawLine(
        Offset(size.width - x, mid),
        Offset(size.width - x - 5, mid),
        paint,
      );
    }

    final c = Offset(size.width / 2, mid);
    canvas.drawPath(
      Path()
        ..moveTo(c.dx, c.dy - half)
        ..lineTo(c.dx + half, c.dy)
        ..lineTo(c.dx, c.dy + half)
        ..lineTo(c.dx - half, c.dy)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(_StitchPainter old) => old.colour != colour;
}
