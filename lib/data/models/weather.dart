import 'package:flutter/foundation.dart';

/// A weather warning. `type` is an open string on the wire
/// (`heavy_rain | heat | …`), so the UI maps known values to an icon and falls
/// back rather than crashing on a type it has not seen.
@immutable
class WeatherAlert {
  const WeatherAlert({
    required this.id,
    required this.type,
    required this.messageBn,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String messageBn;
  final DateTime createdAt;

  factory WeatherAlert.fromJson(Map<String, dynamic> json) => WeatherAlert(
        id: json['id'] as String? ?? '',
        type: json['type'] as String? ?? 'other',
        messageBn: json['message_bn'] as String? ?? '',
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}

@immutable
class WeatherNow {
  const WeatherNow({
    required this.tempC,
    required this.condition,
    required this.humidity,
    required this.windKph,
    this.iconCode = 'cloudy',
  });

  final double tempC;
  final String condition;
  final int humidity;
  final double windKph;
  final String iconCode;

  factory WeatherNow.fromJson(Map<String, dynamic> json) => WeatherNow(
        tempC: (json['temp_c'] as num?)?.toDouble() ?? 0,
        condition: json['condition'] as String? ?? '',
        humidity: (json['humidity'] as num?)?.toInt() ?? 0,
        windKph: (json['wind_kph'] as num?)?.toDouble() ?? 0,
        iconCode: json['icon'] as String? ?? 'cloudy',
      );
}

@immutable
class WeatherDay {
  const WeatherDay({
    required this.date,
    required this.minC,
    required this.maxC,
    required this.condition,
    required this.rainMm,
    this.iconCode = 'cloudy',
  });

  final DateTime date;
  final double minC;
  final double maxC;
  final String condition;
  final double rainMm;
  final String iconCode;

  factory WeatherDay.fromJson(Map<String, dynamic> json) => WeatherDay(
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        minC: (json['min_c'] as num?)?.toDouble() ?? 0,
        maxC: (json['max_c'] as num?)?.toDouble() ?? 0,
        condition: json['condition'] as String? ?? '',
        rainMm: (json['rain_mm'] as num?)?.toDouble() ?? 0,
        iconCode: json['icon'] as String? ?? 'cloudy',
      );
}

/// District weather plus any active alerts.
///
/// `updatedAt` is shown to the farmer whenever the screen is serving cached
/// data, because stale weather presented as live is a safety problem in a
/// cyclone-prone country.
@immutable
class WeatherReport {
  const WeatherReport({
    required this.district,
    required this.current,
    required this.forecast,
    required this.alerts,
    required this.updatedAt,
  });

  final String district;
  final WeatherNow current;
  final List<WeatherDay> forecast;
  final List<WeatherAlert> alerts;
  final DateTime updatedAt;

  bool get hasAlerts => alerts.isNotEmpty;

  factory WeatherReport.fromJson(Map<String, dynamic> json) => WeatherReport(
        district: json['district'] as String? ?? '',
        current:
            WeatherNow.fromJson((json['current'] as Map<String, dynamic>?) ?? {}),
        forecast: ((json['forecast'] as List<dynamic>?) ?? const [])
            .map((e) => WeatherDay.fromJson(e as Map<String, dynamic>))
            .toList(),
        alerts: ((json['alerts'] as List<dynamic>?) ?? const [])
            .map((e) => WeatherAlert.fromJson(e as Map<String, dynamic>))
            .toList(),
        updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
            DateTime.now(),
      );
}
