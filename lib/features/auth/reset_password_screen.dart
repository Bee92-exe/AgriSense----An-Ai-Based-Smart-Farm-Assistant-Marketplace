import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/session_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';

/// FR-3: request an OTP, enter it, set a new password.
///
/// Modelled as an explicit two-step state rather than separate routes, because
/// the OTP is only valid inside this flow and going back must not leave a stale
/// code armed.
enum _Step { request, verify, done }

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _mobile = TextEditingController();
  final _otp = TextEditingController();
  final _password = TextEditingController();

  _Step _step = _Step.request;
  bool _busy = false;
  bool _failed = false;

  @override
  void dispose() {
    _mobile.dispose();
    _otp.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await ref.read(authRepositoryProvider).requestOtp(_mobile.text.trim());
    } catch (_) {
      // The request endpoint is deliberately generic: it must not reveal whether
      // the number exists, so a failure here is not shown either.
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _step = _Step.verify;
    });
  }

  Future<void> _submitOtp() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    final ok = await ref.read(sessionProvider.notifier).resetPassword(
          mobile: _mobile.text.trim(),
          otp: _otp.text.trim(),
          newPassword: _password.text,
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _failed = !ok;
      _step = ok ? _Step.done : _Step.verify;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(title: Text(l.loginForgot)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(Space.md),
          children: [
            switch (_step) {
              _Step.request => _mobileStep(l),
              _Step.verify => _otpStep(l),
              _Step.done => _doneStep(l),
            },
          ],
        ),
      ),
    );
  }

  Widget _mobileStep(AppL10n l) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.loginSubtitle,
            style: context.texts.bodyMedium
                ?.copyWith(color: context.palette.onSurfaceMuted),
          ),
          const SizedBox(height: Space.lg),
          TextField(
            controller: _mobile,
            keyboardType: TextInputType.phone,
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
          const SizedBox(height: Space.lg),
          AppButton(
            label: l.otpResend,
            isLoading: _busy,
            onPressed: _mobile.text.trim().length == 11 ? _requestOtp : null,
          ),
        ],
      );

  Widget _otpStep(AppL10n l) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.otpBody(_mobile.text.trim()),
            style: context.texts.bodyMedium
                ?.copyWith(color: context.palette.onSurfaceMuted),
          ),
          const SizedBox(height: Space.lg),
          TextField(
            controller: _otp,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              labelText: l.otpLabel,
              hintText: l.otpHint,
              prefixIcon: const Icon(Icons.password_rounded),
            ),
          ),
          const SizedBox(height: Space.md),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l.registerPasswordLabel,
              helperText: l.registerPasswordRule,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              errorText: _failed ? l.otpInvalid : null,
            ),
          ),
          const SizedBox(height: Space.lg),
          AppButton(
            label: l.otpSubmit,
            isLoading: _busy,
            onPressed: _submitOtp,
          ),
          TextButton(
            onPressed: _requestOtp,
            child: Text(l.otpResend),
          ),
        ],
      );

  Widget _doneStep(AppL10n l) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Space.lg),
          Icon(
            Icons.check_circle_rounded,
            size: 72,
            color: context.palette.primary,
          ),
          const SizedBox(height: Space.md),
          Text(
            l.profileSaved,
            textAlign: TextAlign.center,
            style: context.texts.titleLarge,
          ),
          const SizedBox(height: Space.lg),
          AppButton(
            label: l.loginSubmit,
            onPressed: () => context.go(Routes.login),
          ),
        ],
      );
}
