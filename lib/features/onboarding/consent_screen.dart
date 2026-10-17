import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/settings_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../l10n/app_localizations.dart';

/// One consent the farmer is asked for, with its own switch.
///
/// Doc 04 requires consent per purpose, recorded with a version. Asking for one
/// blanket "I agree" is the pattern this screen exists to avoid, so each toggle
/// states what is collected, why, and who can see it.
class _ConsentItem {
  const _ConsentItem({
    required this.type,
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
    this.required = false,
  });

  final String type;
  final String titleKey;
  final String bodyKey;
  final IconData icon;

  /// Photos are the only thing the product cannot work without, so it is on by
  /// default and cannot be switched off here — the alternative is not using the
  /// diagnosis feature at all.
  final bool required;
}

const _items = <_ConsentItem>[
  _ConsentItem(
    type: 'photos',
    titleKey: 'consentPhotosTitle',
    bodyKey: 'consentPhotosBody',
    icon: Icons.photo_camera_rounded,
    required: true,
  ),
  _ConsentItem(
    type: 'location',
    titleKey: 'consentLocationTitle',
    bodyKey: 'consentLocationBody',
    icon: Icons.place_rounded,
  ),
  _ConsentItem(
    type: 'phone',
    titleKey: 'consentPhoneTitle',
    bodyKey: 'consentPhoneBody',
    icon: Icons.phone_android_rounded,
  ),
  _ConsentItem(
    type: 'voice_retention',
    titleKey: 'consentVoiceTitle',
    bodyKey: 'consentVoiceBody',
    icon: Icons.mic_rounded,
  ),
];

class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  final Map<String, bool> _granted = {
    'photos': true,
    'location': true,
    'phone': true,
    'voice_retention': false,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(title: Text(l.consentTitle)),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: Space.md),
                children: [
                  Text(
                    l.consentSubtitle,
                    style: context.texts.bodyMedium
                        ?.copyWith(color: p.onSurfaceMuted),
                  ),
                  const SizedBox(height: Space.md),
                  for (final item in _items) ...[
                    _ConsentCard(
                      item: item,
                      value: item.required ? true : (_granted[item.type] ?? false),
                      onChanged: (v) => setState(() => _granted[item.type] = v),
                    ),
                    const SizedBox(height: Space.sm),
                  ],
                  const SizedBox(height: Space.xs),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                children: [
                  AppButton(
                    label: l.consentAccept,
                    icon: Icons.check_rounded,
                    onPressed: () async {
                      await ref
                          .read(settingsProvider.notifier)
                          .completeConsentStep();
                      if (context.mounted) context.go(Routes.login);
                    },
                  ),
                  const SizedBox(height: Space.xs),
                  TextButton(
                    onPressed: () async {
                      // Declining is a real choice: everything except the
                      // diagnosis photo keeps working, so the app still opens.
                      await ref
                          .read(settingsProvider.notifier)
                          .completeConsentStep();
                      if (context.mounted) context.go(Routes.login);
                    },
                    child: Text(l.consentDecline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentCard extends StatelessWidget {
  const _ConsentCard({
    required this.item,
    required this.value,
    required this.onChanged,
  });

  final _ConsentItem item;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);

    final title = switch (item.titleKey) {
      'consentPhotosTitle' => l.consentPhotosTitle,
      'consentLocationTitle' => l.consentLocationTitle,
      'consentPhoneTitle' => l.consentPhoneTitle,
      _ => l.consentVoiceTitle,
    };
    final body = switch (item.bodyKey) {
      'consentPhotosBody' => l.consentPhotosBody,
      'consentLocationBody' => l.consentLocationBody,
      'consentPhoneBody' => l.consentPhoneBody,
      _ => l.consentVoiceBody,
    };

    return AppCard(
      padding: const EdgeInsets.all(Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: p.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: p.onPrimaryContainer),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: context.texts.titleSmall),
                    ),
                    Switch(
                      value: value,
                      onChanged: item.required ? null : onChanged,
                    ),
                  ],
                ),
                Text(
                  body,
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
