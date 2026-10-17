import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injected in `main()` once `SharedPreferences.getInstance()` has resolved, so
/// every settings read is synchronous and no screen has to show a spinner for a
/// boolean.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  ),
);

/// Appearance and language preferences.
///
/// These live on the device rather than only on the server because a farmer must
/// get Bangla and sunlight mode on first launch, before any network call
/// succeeds.
class AppSettings {
  const AppSettings({
    this.language = 'bn',
    this.highContrast = false,
    this.voiceMode = false,
    this.animatedMode = false,
    this.languageChosen = false,
    this.consentGiven = false,
  });

  final String language;
  final bool highContrast;

  /// When true, results are read aloud automatically instead of on tap.
  final bool voiceMode;

  /// অ্যানিমেশন mode: slow ambient motion on the Home hero that follows the real
  /// weather and clock.
  ///
  /// Independent of [highContrast] rather than a third exclusive option, so a
  /// farmer can have the moving sky in normal mode and the flat, glare-proof
  /// panel in sunlight mode without giving up either. Off by default: it is a
  /// decoration, and a decoration must never be the reason a phone feels slow.
  final bool animatedMode;

  /// First-run gates. The router sends a brand-new install to the language pick
  /// and then the consent screen before it will show a login form.
  final bool languageChosen;
  final bool consentGiven;

  AppSettings copyWith({
    String? language,
    bool? highContrast,
    bool? voiceMode,
    bool? animatedMode,
    bool? languageChosen,
    bool? consentGiven,
  }) =>
      AppSettings(
        language: language ?? this.language,
        highContrast: highContrast ?? this.highContrast,
        voiceMode: voiceMode ?? this.voiceMode,
        animatedMode: animatedMode ?? this.animatedMode,
        languageChosen: languageChosen ?? this.languageChosen,
        consentGiven: consentGiven ?? this.consentGiven,
      );
}

class SettingsNotifier extends Notifier<AppSettings> {
  static const _kLanguage = 'settings.language';
  static const _kContrast = 'settings.high_contrast';
  static const _kVoice = 'settings.voice_mode';
  static const _kAnimated = 'settings.animated_mode';
  static const _kLanguageChosen = 'settings.language_chosen';
  static const _kConsentGiven = 'settings.consent_given';

  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppSettings(
      language: prefs.getString(_kLanguage) ?? 'bn',
      highContrast: prefs.getBool(_kContrast) ?? false,
      voiceMode: prefs.getBool(_kVoice) ?? false,
      animatedMode: prefs.getBool(_kAnimated) ?? false,
      languageChosen: prefs.getBool(_kLanguageChosen) ?? false,
      consentGiven: prefs.getBool(_kConsentGiven) ?? false,
    );
  }

  Future<void> completeLanguageStep() async {
    state = state.copyWith(languageChosen: true);
    await ref.read(sharedPreferencesProvider).setBool(_kLanguageChosen, true);
  }

  Future<void> completeConsentStep() async {
    state = state.copyWith(consentGiven: true);
    await ref.read(sharedPreferencesProvider).setBool(_kConsentGiven, true);
  }

  Future<void> setLanguage(String code) async {
    state = state.copyWith(language: code);
    await ref.read(sharedPreferencesProvider).setString(_kLanguage, code);
  }

  Future<void> setHighContrast(bool value) async {
    state = state.copyWith(highContrast: value);
    await ref.read(sharedPreferencesProvider).setBool(_kContrast, value);
  }

  Future<void> setVoiceMode(bool value) async {
    state = state.copyWith(voiceMode: value);
    await ref.read(sharedPreferencesProvider).setBool(_kVoice, value);
  }

  Future<void> setAnimatedMode(bool value) async {
    state = state.copyWith(animatedMode: value);
    await ref.read(sharedPreferencesProvider).setBool(_kAnimated, value);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
