import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Number, money and date formatting for the app.
///
/// The design system requires **Bangla digits by default**. `intl` already knows
/// that the `bn` locale uses the Bengali numbering system, so the rule is simply
/// "always format through here, never with `toString()` or `NumberFormat()`
/// defaulted to the ambient locale". Verified by `test/formatters_test.dart`.
class AppFormat {
  AppFormat(this.localeName);

  /// Reads the locale the app is actually running in, so a user who switched to
  /// English gets Latin digits without any screen having to ask.
  factory AppFormat.of(BuildContext context) =>
      AppFormat(Localizations.localeOf(context).languageCode);

  final String localeName;

  bool get usesBanglaDigits => localeName == 'bn';

  NumberFormat _decimal({int? decimals}) => decimals == null
      ? NumberFormat.decimalPattern(localeName)
      : NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: decimals,
        );

  /// `1250` -> `১,২৫০` (bn) / `1,250` (en)
  String number(num value, {int? decimals}) =>
      _decimal(decimals: decimals).format(value);

  /// `0.91` -> `৯১%`. Confidence is stored 0-1 everywhere, so this takes the
  /// fraction and does the multiplication, keeping the call sites honest.
  String percentFromFraction(double fraction, {int decimals = 0}) =>
      '${_decimal(decimals: decimals).format(fraction * 100)}%';

  /// Money is integer taka end-to-end (see API_SPEC "Money: integer BDT"), so
  /// this never invents paisa.
  String taka(int amount) => '${_decimal().format(amount)} ৳';

  DateTime _asDate(dynamic value) =>
      value is DateTime ? value : DateTime.parse(value as String);

  /// `12/06/2026` in the locale's own pattern.
  String shortDate(dynamic value) =>
      DateFormat.yMd(localeName).format(_asDate(value));

  /// `১২ জুন, ২০২৬`
  String longDate(dynamic value) =>
      DateFormat.yMMMMd(localeName).format(_asDate(value));

  /// `১২ জুন, ২০২৬ · ৩:০৫ PM`
  String dateTime(dynamic value) =>
      DateFormat.yMMMMd(localeName).add_jm().format(_asDate(value));

  /// Month name only, for the seasonal calendar strip.
  String monthName(int month) =>
      DateFormat.MMMM(localeName).format(DateTime(2026, month));

  /// Short weekday for forecast rows.
  String weekday(dynamic value) =>
      DateFormat.E(localeName).format(_asDate(value));

  /// "2 hours ago" style, for the news list. Falls back to a date beyond a week
  /// because a relative label stops being useful out there.
  String relative(dynamic value) {
    final then = _asDate(value);
    final diff = DateTime.now().difference(then);
    if (diff.inMinutes < 1) return usesBanglaDigits ? 'এইমাত্র' : 'just now';
    if (diff.inMinutes < 60) {
      return usesBanglaDigits
          ? '${number(diff.inMinutes)} মিনিট আগে'
          : '${number(diff.inMinutes)} min ago';
    }
    if (diff.inHours < 24) {
      return usesBanglaDigits
          ? '${number(diff.inHours)} ঘণ্টা আগে'
          : '${number(diff.inHours)} h ago';
    }
    if (diff.inDays < 7) {
      return usesBanglaDigits
          ? '${number(diff.inDays)} দিন আগে'
          : '${number(diff.inDays)} d ago';
    }
    return shortDate(then);
  }
}
