import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/session_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ambience.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock/mock_repositories.dart';
import '../../data/repositories/auth_repository.dart';
import '../../l10n/app_localizations.dart';

/// Mobile number and password (decision A5 — OTP is for password reset, not for
/// daily sign-in).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _mobile.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    await ref.read(sessionProvider.notifier).login(
          mobile: _mobile.text.trim(),
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final session = ref.watch(sessionProvider);

    // A failed login lands here as an AsyncError; the form shows the Bangla
    // message the repository produced.
    final error = session.hasError ? session.error : null;
    final errorText = error is ApiException
        ? _messageFor(error, l)
        : error == null
            ? null
            : l.stateErrorBody;

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(title: Text(l.loginTitle)),
      body: AmbientBackdrop(
        mood: AmbienceMood.auth,
        child: SafeArea(
          top: false,
          child: PageReveal(
            child: ListView(
              padding: const EdgeInsets.all(Space.md),
              children: [
            Text(
              l.loginSubtitle,
              style: context.texts.bodyMedium?.copyWith(color: p.onSurfaceMuted),
            ),
            const SizedBox(height: Space.lg),
            TextField(
              controller: _mobile,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: InputDecoration(
                labelText: l.loginMobileLabel,
                hintText: l.loginMobileHint,
                prefixIcon: const Icon(Icons.phone_android_rounded),
              ),
            ),
            const SizedBox(height: Space.md),
            TextField(
              controller: _password,
              obscureText: _obscure,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l.loginPasswordLabel,
                hintText: l.loginPasswordHint,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                  tooltip: l.loginPasswordLabel,
                ),
                errorText: errorText,
              ),
            ),
            const SizedBox(height: Space.md),
            AppButton(
              label: l.loginSubmit,
              isLoading: session.isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: Space.xs),
            TextButton(
              onPressed: () => context.push(Routes.reset),
              child: Text(l.loginForgot),
            ),
            const SizedBox(height: Space.md),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  l.obAccountTitle,
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                ),
                TextButton(
                  onPressed: () => context.push(Routes.register),
                  child: Text(l.obRegister),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            _DemoCredentialsHint(
              onFill: (mobile, password) => setState(() {
                _mobile.text = mobile;
                _password.text = password;
              }),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _messageFor(ApiException e, AppL10n l) {
    if (e.code == 'unauthorized') return l.loginFailed;
    return l.stateErrorBody;
  }
}

/// Shown because the app currently runs on mock data — without it the login
/// screen is unusable and the demo depends on someone reading the source.
/// Removed the moment `USE_MOCK=false` is the default.
class _DemoCredentialsHint extends StatelessWidget {
  const _DemoCredentialsHint({required this.onFill});

  /// Tapping a row fills the form, so the demo does not require transcribing a
  /// number from the screen.
  final void Function(String mobile, String password) onFill;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    return AppCard(
      tint: p.surfaceSunken,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science_rounded, size: 18, color: p.onSurfaceMuted),
              const SizedBox(width: Space.xs),
              Expanded(
                child: Text(
                  isBangla ? 'ডেমো অ্যাকাউন্ট' : 'Demo accounts',
                  style: context.texts.labelSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          for (final entry in kDemoAccounts.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () => onFill(
                  entry.key,
                  entry.value['password'] as String,
                ),
                child: Text(
                  '${entry.key}  ·  ${entry.value['role']}  ·  '
                  '${entry.value['password']}',
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
