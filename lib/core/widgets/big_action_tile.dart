import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_theme.dart';
import 'alpona.dart';

/// One of the six big actions on the farmer Home screen.
///
/// Deliberately not a Material `Card` with a list tile: this is the primary
/// navigation surface for someone who may read slowly, so it gets a large glyph,
/// a large label, its own tint, and a press state you can feel. Tint index is
/// passed in rather than derived so the grid stays a fixed, learnable map.
///
/// The tile wears its tint as a wash and keeps its label in ink. That is the one
/// change the patachitra identity asks for here: six saturated fills would be a
/// colour chip chart with text on top, while six pale washes with an outlined
/// plate read as one set of painted tiles — and every label sits at 15:1.
class BigActionTile extends StatefulWidget {
  const BigActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.tintIndex,
    required this.onTap,
    this.hint,
    this.badgeCount,
  });

  final IconData icon;
  final String label;
  final String? hint;
  final int tintIndex;
  final VoidCallback onTap;

  /// Small count bubble, e.g. unread Krishi Barta items.
  final int? badgeCount;

  @override
  State<BigActionTile> createState() => _BigActionTileState();
}

class _BigActionTileState extends State<BigActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final tint = p.actionTints[widget.tintIndex % p.actionTints.length];
    final radius = Radii.tileAll;

    return Semantics(
      button: true,
      label:
          widget.hint == null ? widget.label : '${widget.label}. ${widget.hint}',
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: Motion.duration(context, Motion.fast),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint.background,
            borderRadius: radius,
            border: Border.all(color: p.outline, width: p.borderWidth),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                // A watermark of the tile's own glyph, bleeding off the corner.
                // It is what keeps six flat rectangles from reading as a
                // settings menu, and at 10% alpha it can never compete with the
                // label.
                Positioned(
                  right: -14,
                  bottom: -10,
                  child: Icon(
                    widget.icon,
                    size: 104,
                    color: tint.foreground.withValues(alpha: 0.10),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: radius,
                    onHighlightChanged: (v) => setState(() => _pressed = v),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: Sizes.actionTileHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Space.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Medallion(
                                  icon: widget.icon,
                                  size: Sizes.medallionLarge,
                                  background:
                                      tint.foreground.withValues(alpha: 0.14),
                                  foreground: tint.foreground,
                                ),
                                const Spacer(),
                                if (widget.badgeCount != null &&
                                    widget.badgeCount! > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Space.xs,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: p.error,
                                      borderRadius: Radii.chipAll,
                                    ),
                                    child: Text(
                                      '${widget.badgeCount}',
                                      style:
                                          context.texts.labelSmall?.copyWith(
                                        color: p.onError,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: Space.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.label,
                                  style: context.texts.titleMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.hint != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      widget.hint!,
                                      style: context.texts.bodySmall
                                          ?.copyWith(color: p.onSurfaceMuted),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
