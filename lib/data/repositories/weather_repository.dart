import '../models/weather.dart';

abstract interface class WeatherRepository {
  /// District defaults to the user's profile district when [district] is null
  /// (API_SPEC §5).
  Future<WeatherReport> report({String? district});

  Future<List<WeatherAlert>> activeAlerts({String? district});
}
