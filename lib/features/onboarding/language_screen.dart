import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/settings_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../l10n/app_localizations.dart';

/// First screen of a fresh install.
///
/// Bangla is preselected and shown first because it is the default for every
/// user of this app; English is the deliberate alternative, not the starting
/// point. Both options are large tap targets with the language's own name, so
/// the screen is legible to someone who cannot read the other one.
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String _selected = 'bn';

  @override
  void initState() {
    super.initState();
    _selected = ref.read(settingsProvider).language;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final t = context.texts;

    return Scaffold(
      backgroundColor: p.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Icon(Icons.eco_rounded, size: 72, color: p.primary),
              const SizedBox(height: Space.md),
              Text(
                l.appName,
                textAlign: TextAlign.center,
                style: t.displayLarge?.copyWith(color: p.primary),
              ),
              const SizedBox(height: Space.xxs),
              Text(
                l.appTagline,
                textAlign: TextAlign.center,
                style: t.bodyLarge?.copyWith(color: p.onSurfaceMuted),
              ),
              const Spacer(),
              Text(l.languageTitle, style: t.titleLarge),
              const SizedBox(height: Space.xxs),
              Text(
                l.languageSubtitle,
                style: t.bodyMedium?.copyWith(color: p.onSurfaceMuted),
              ),
              const SizedBox(height: Space.md),
              _LanguageOption(
                label: l.languageBangla,
                sample: 'কৃষি পরামর্শ',
                selected: _selected == 'bn',
                onTap: () => setState(() => _selected = 'bn'),
              ),
              const SizedBox(height: Space.sm),
              _LanguageOption(
                label: l.languageEnglish,
                sample: 'Farming advice',
                selected: _selected == 'en',
                onTap: () => setState(() => _selected = 'en'),
              ),
              const Spacer(flex: 2),
              AppButton(
                label: l.languageContinue,
                icon: Icons.arrow_forward_rounded,
                onPressed: () async {
                  await ref
                      .read(settingsProvider.notifier)
                      .setLanguage(_selected);
                  await ref
                      .read(settingsProvider.notifier)
                      .completeLanguageStep();
                  if (context.mounted) context.go(Routes.consent);
                },
              ),
              const SizedBox(height: Space.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.sample,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String sample;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Material(
        color: selected ? p.primaryContainer : p.surface,
        borderRadius: Radii.cardAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: Radii.cardAll,
          child: Container(
            constraints: const BoxConstraints(minHeight: 88),
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(
              borderRadius: Radii.cardAll,
              border: Border.all(
                color: selected ? p.primary : p.outline,
                width: selected ? p.borderWidth + 1 : p.borderWidth,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: context.texts.titleLarge?.copyWith(
                          color: selected ? p.onPrimaryContainer : p.onSurface,
                        ),
                      ),
                      Text(
                        sample,
                        style: context.texts.bodySmall?.copyWith(
                          color: selected
                              ? p.onPrimaryContainer
                              : p.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 28,
                  color: selected ? p.primary : p.onSurfaceMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
