import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/session_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ambience.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/states.dart';
import '../../data/models/enums.dart';
import '../../core/utils/labels.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/farmer_shell.dart';

/// Profile and settings.
///
/// Sits behind the same tap floor as everything else even though it is the
/// densest screen in the app: a switch a farmer cannot hit is a setting they
/// cannot change. Sunlight mode and language live here as well as on Home
/// because this is where someone looks for them.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider);

    if (user == null) {
      return AppScreen(
        title: l.profileTitle,
        showBack: false,
        child: const EmptyState(
          icon: Icons.person_off_rounded,
          title: '—',
        ),
      );
    }

    return AppScreen(
      title: l.profileTitle,
      showBack: false,
      bottomNav: const FarmerNav(current: FarmerTab.profile),
      fab: const FarmerMicFab(),
      ambience: AmbienceMood.profile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: p.primaryContainer,
                  child: Text(
                    user.initials,
                    style: context.texts.titleLarge
                        ?.copyWith(color: p.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: context.texts.titleSmall),
                      Text(
                        user.mobile,
                        style: context.texts.bodySmall
                            ?.copyWith(color: p.onSurfaceMuted),
                      ),
                      const SizedBox(height: Space.xxs),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Space.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: p.surfaceSunken,
                              borderRadius: Radii.chipAll,
                              border: Border.all(
                                color: p.outline,
                                width: p.borderWidth,
                              ),
                            ),
                            child: Text(
                              user.role.label(l),
                              style: context.texts.labelSmall,
                            ),
                          ),
                          if (user.role == Role.vendor) ...[
                            const SizedBox(width: Space.xs),
                            VerifiedBadge(
                              verified: user.vendor?.isVerified ?? false,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          SectionHeader(
            title: l.profileSettings,
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: Space.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingRow(
                  icon: Icons.language_rounded,
                  title: l.profileLanguage,
                  stacked: true,
                  trailing: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'bn', label: Text(l.languageBangla)),
                      ButtonSegment(value: 'en', label: Text(l.languageEnglish)),
                    ],
                    selected: {settings.language},
                    onSelectionChanged: (s) => ref
                        .read(settingsProvider.notifier)
                        .setLanguage(s.first),
                  ),
                ),
                const Divider(height: 1),
                _SettingRow(
                  icon: Icons.light_mode_rounded,
                  title: l.profileContrast,
                  subtitle: l.homeContrastToggleHint,
                  trailing: Switch(
                    value: settings.highContrast,
                    onChanged: (v) => ref
                        .read(settingsProvider.notifier)
                        .setHighContrast(v),
                  ),
                ),
                const Divider(height: 1),
                _SettingRow(
                  icon: Icons.auto_awesome_rounded,
                  title: l.profileAnimation,
                  subtitle: l.profileAnimationHint,
                  trailing: Switch(
                    value: settings.animatedMode,
                    onChanged: (v) => ref
                        .read(settingsProvider.notifier)
                        .setAnimatedMode(v),
                  ),
                ),
                const Divider(height: 1),
                _SettingRow(
                  icon: Icons.mic_rounded,
                  title: l.profileVoiceMode,
                  subtitle: l.profileVoiceModeHint,
                  trailing: Switch(
                    value: settings.voiceMode,
                    onChanged: (v) =>
                        ref.read(settingsProvider.notifier).setVoiceMode(v),
                  ),
                ),
                const Divider(height: 1),
                _SettingRow(
                  icon: Icons.notifications_active_outlined,
                  title: l.profileNotifications,
                  trailing: Switch(
                    value: true,
                    // Notification delivery is server-side (FCM) and is not
                    // built yet; the switch is shown disabled rather than
                    // pretending to work.
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          SectionHeader(title: l.consentTitle, icon: Icons.privacy_tip_outlined),
          const SizedBox(height: Space.xs),
          AppCard(
            tint: p.surfaceSunken,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.consentSubtitle,
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                ),
                const SizedBox(height: Space.sm),
                Text(
                  l.profileVersion('1.0.0'),
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          AppButton(
            label: l.profileLogout,
            tone: AppButtonTone.secondary,
            icon: Icons.logout_rounded,
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(l.profileLogoutConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: Text(l.actionCancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: Text(l.actionConfirm),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(sessionProvider.notifier).logout();
              }
            },
          ),
          const SizedBox(height: Space.xs),
          AppButton(
            label: l.profileDeleteAccount,
            tone: AppButtonTone.quiet,
            icon: Icons.delete_outline_rounded,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.comingSoonBody)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.trailing,
    this.subtitle,
    this.stacked = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;

  /// Rows whose control is wide (a segmented language switch) put it on its own
  /// line instead of squeezing the title beside it.
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: context.texts.titleSmall),
        if (subtitle != null)
          Text(
            subtitle!,
            style: context.texts.bodySmall?.copyWith(color: p.onSurfaceMuted),
          ),
      ],
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: Sizes.minTapTarget),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.xs,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // A language switcher is ~180dp wide. On a small phone, with the
            // Bangla title beside it, the row used to overflow and the switch
            // was painted outside the card. Stack instead of squeezing.
            final stacked = this.stacked && constraints.maxWidth < 420;
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: p.onSurfaceMuted),
                      const SizedBox(width: Space.sm),
                      Expanded(child: label),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Space.xs),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: trailing,
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Icon(icon, color: p.onSurfaceMuted),
                const SizedBox(width: Space.sm),
                Expanded(child: label),
                trailing,
              ],
            );
          },
        ),
      ),
    );
  }
}
