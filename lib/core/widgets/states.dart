import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_metrics.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'app_button.dart';

/// A single shimmering placeholder block.
///
/// The pulse is the only looping animation in the app besides the mic ring, and
/// it collapses to a static block under reduce-motion.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = Sizes.skeleton,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Motion.pulse,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final reduced = MediaQuery.disableAnimationsOf(context);

    if (reduced) {
      return _box(p.surfaceSunken);
    }
    _c.repeat(reverse: true);
    return FadeTransition(
      opacity: Tween<double>(begin: 0.55, end: 1).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut),
      ),
      child: _box(p.surfaceSunken),
    );
  }

  Widget _box(Color color) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: widget.borderRadius,
        ),
      );
}

/// Loading placeholder shaped like real content, so the page does not reflow
/// into place when data lands.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.rows = 3, this.showHeader = true});

  final int rows;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppL10n.of(context).stateLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            const Skeleton(width: 180, height: 28),
            const SizedBox(height: Space.md),
          ],
          for (var i = 0; i < rows; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: Row(
                children: [
                  const Skeleton(width: 64, height: 64),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Skeleton(width: double.infinity, height: 20),
                        SizedBox(height: Space.xs),
                        Skeleton(width: 140, height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Friendly empty state. Always offers the next step — an empty screen with no
/// way forward is a dead end for a first-time user.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = context.texts;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: p.surfaceSunken,
                shape: BoxShape.circle,
                border: Border.all(color: p.outline, width: p.borderWidth),
              ),
              child: Icon(icon, size: 48, color: p.primary),
            ),
            const SizedBox(height: Space.md),
            Text(title, style: t.titleLarge, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: Space.xs),
              Text(
                body!,
                style: t.bodyMedium?.copyWith(color: p.onSurfaceMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: Space.lg),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                tone: AppButtonTone.secondary,
                expand: false,
                icon: Icons.arrow_forward_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state. Says what happened in Bangla and always gives a way out; never
/// surfaces a raw exception or a stack trace.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title,
    this.body,
    this.onRetry,
    this.retryLabel,
    this.extraActionLabel,
    this.onExtraAction,
  });

  final String? title;
  final String? body;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final String? extraActionLabel;
  final VoidCallback? onExtraAction;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = context.texts;
    final l = AppL10n.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: p.errorContainer,
                shape: BoxShape.circle,
                border: Border.all(color: p.error, width: p.borderWidth),
              ),
              child: Icon(Icons.cloud_off_rounded, size: 48, color: p.error),
            ),
            const SizedBox(height: Space.md),
            Text(
              title ?? l.stateErrorTitle,
              style: t.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.xs),
            Text(
              body ?? l.stateErrorBody,
              style: t.bodyMedium?.copyWith(color: p.onSurfaceMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.lg),
            if (onRetry != null)
              AppButton(
                label: retryLabel ?? l.actionRetry,
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
              ),
            if (extraActionLabel != null && onExtraAction != null) ...[
              const SizedBox(height: Space.sm),
              AppButton(
                label: extraActionLabel!,
                onPressed: onExtraAction,
                tone: AppButtonTone.secondary,
                icon: Icons.person_outline_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Banner shown while the device is offline. Names the consequence (photos go up
/// later) instead of just reporting a network state.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.queuedCount = 0, this.onSync});

  final int queuedCount;
  final VoidCallback? onSync;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);
    final f = AppFormat.of(context);

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.sm,
        ),
        decoration: BoxDecoration(
          color: p.harvestContainer,
          border: Border(
            bottom: BorderSide(color: p.outline, width: p.borderWidth),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off_rounded, color: p.onHarvestContainer),
            const SizedBox(width: Space.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.offlineBanner,
                    style: context.texts.labelSmall?.copyWith(
                      color: p.onHarvestContainer,
                    ),
                  ),
                  if (queuedCount > 0)
                    Text(
                      l.offlineQueued(queuedCount, f.number(queuedCount)),
                      style: context.texts.bodySmall?.copyWith(
                        color: p.onHarvestContainer,
                      ),
                    ),
                ],
              ),
            ),
            if (onSync != null)
              TextButton(
                onPressed: onSync,
                child: Text(
                  l.actionRetry,
                  style: context.texts.labelSmall?.copyWith(
                    color: p.onHarvestContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The standing "this is guidance, not a diagnosis" line. Lives in the widget
/// library so no screen can quietly forget it.
class DisclaimerNote extends StatelessWidget {
  const DisclaimerNote({super.key, this.text, this.icon = Icons.info_outline_rounded});

  final String? text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);

    return Container(
      padding: const EdgeInsets.all(Space.sm),
      decoration: BoxDecoration(
        color: p.surfaceSunken,
        borderRadius: Radii.fieldAll,
        border: Border.all(color: p.outline, width: p.borderWidth),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: p.onSurfaceMuted),
          const SizedBox(width: Space.xs),
          Expanded(
            child: Text(
              text ?? l.aiDisclaimer,
              style: context.texts.bodySmall?.copyWith(color: p.onSurfaceMuted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder for a route that exists but is not built yet. Says so plainly
/// rather than pretending to be broken.
class ComingSoonState extends StatelessWidget {
  const ComingSoonState({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return EmptyState(
      icon: Icons.construction_rounded,
      title: l.comingSoon,
      body: l.comingSoonBody,
    );
  }
}
