import 'package:flutter/material.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_metrics.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/labels.dart';

/// "AI" tag. Every AI-produced block in the app carries one, so a farmer can
/// tell a machine's output from an expert's without reading a disclaimer.
class AiBadge extends StatelessWidget {
  const AiBadge({super.key, this.tooltip});

  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);

    return Tooltip(
      message: tooltip ?? l.aiDisclaimer,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: 2),
        decoration: BoxDecoration(
          color: p.aiContainer,
          borderRadius: Radii.chipAll,
          border: Border.all(color: p.aiAccent, width: p.borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 14, color: p.onAiContainer),
            const SizedBox(width: 4),
            Text(
              l.aiBadge,
              style: context.texts.labelSmall?.copyWith(
                color: p.onAiContainer,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Severity pill. Icon + Bangla label + colour, never colour alone.
class SeverityChip extends StatelessWidget {
  const SeverityChip({super.key, required this.severity, this.compact = false});

  final Severity severity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);
    final (foreground, background) = switch (severity) {
      Severity.low => (p.severityLow, p.severityLowContainer),
      Severity.medium => (p.severityMedium, p.severityMediumContainer),
      Severity.high => (p.severityHigh, p.severityHighContainer),
      Severity.urgent => (p.severityUrgent, p.severityUrgentContainer),
    };

    return Semantics(
      label: '${l.weatherAlertsTitle}: ${severity.label(l)}',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? Space.xs : Space.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: Radii.chipAll,
          border: Border.all(color: foreground, width: p.borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(severity.icon, size: 16, color: foreground),
            const SizedBox(width: 4),
            Text(
              severity.label(l),
              style: context.texts.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Confidence read-out: level icon + Bangla level words + the actual percentage.
///
/// All three signals are shown together on purpose. The number is what the SRS
/// means by "honest about AI"; the words and icon are what a low-literacy user
/// actually reads. A low score never renders as a disease — that decision lives
/// in [ConfidenceLevel], this widget only reports.
class ConfidenceBadge extends StatelessWidget {
  const ConfidenceBadge({
    super.key,
    required this.score,
    this.level,
    this.showPercent = true,
    this.compact = false,
  });

  final double score;

  /// Drops the two Bangla words and keeps the icon plus the number. Used where
  /// the badge shares a narrow card with other content — a 164dp photo card
  /// cannot hold "আত্মবিশ্বাস · ৭৪%" without pushing the number out of the card.
  /// The full wording stays in the semantics label either way.
  final bool compact;

  /// Override when the server sends `confidence_level` and it should win over
  /// the locally computed band (e.g. a threshold change on the server).
  final ConfidenceLevel? level;

  final bool showPercent;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);
    final lvl = level ?? ConfidenceLevel.fromScore(score);

    final foreground = switch (lvl) {
      ConfidenceLevel.high => p.confidenceHigh,
      ConfidenceLevel.medium => p.confidenceMedium,
      ConfidenceLevel.low => p.confidenceLow,
    };

    return Semantics(
      label: '${l.diagnosisConfidenceLabel} '
          '${AppFormat.of(context).percentFromFraction(score)} '
          '${lvl.label(l)}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(lvl.icon, size: 18, color: foreground),
          const SizedBox(width: 4),
          if (!compact)
            Flexible(
              child: Text(
                lvl.label(l),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.texts.labelSmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (showPercent) ...[
            Text(
              compact ? '' : ' · ',
              style: context.texts.labelSmall?.copyWith(color: foreground),
            ),
            Text(
              AppFormat.of(context).percentFromFraction(score),
              style: context.texts.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Trust cue for an admin-approved vendor. A tick alone would not mean anything
/// to a farmer, so it always carries the word for it too.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, required this.verified, this.label});

  final bool verified;

  /// Overrides the wording for dense rows (a product tile has ~146dp of width,
  /// and the full "যাচাইকৃত বিক্রেতা" does not fit at the 16sp floor). The
  /// semantics label always keeps the full sentence.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);

    if (!verified) return const SizedBox.shrink();

    return Semantics(
      label: l.vendorVerified,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: 2),
        decoration: BoxDecoration(
          color: p.primaryContainer,
          borderRadius: Radii.chipAll,
          border: Border.all(color: p.primary, width: p.borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded, size: 16, color: p.onPrimaryContainer),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label ?? l.vendorVerified,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.texts.labelSmall?.copyWith(
                  color: p.onPrimaryContainer,
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

/// Upload state for a queued offline photo.
class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({super.key, required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);

    final (foreground, background) = switch (status) {
      SyncStatus.synced => (p.severityLow, p.severityLowContainer),
      SyncStatus.failed => (p.severityUrgent, p.severityUrgentContainer),
      _ => (p.onSurfaceMuted, p.surfaceSunken),
    };

    return Semantics(
      label: status.label(l),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: 2),
        decoration: BoxDecoration(
          color: background,
          borderRadius: Radii.chipAll,
          border: Border.all(color: foreground, width: p.borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 14, color: foreground),
            const SizedBox(width: 4),
            Text(
              status.label(l),
              style: context.texts.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
