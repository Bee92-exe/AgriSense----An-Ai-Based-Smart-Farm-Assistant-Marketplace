import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock/mock_repositories.dart';
import 'repositories/auth_repository.dart';
import 'repositories/diagnosis_repository.dart';
import 'repositories/market_repository.dart';
import 'repositories/news_repository.dart';
import 'repositories/weather_repository.dart';

/// Phase 1 runs entirely against mocks (`--dart-define=USE_MOCK=false` switches
/// it off once the real backend exists). This is the single place the UI could
/// ever learn which one it is talking to, and no widget should ask.
final useMockProvider = Provider<bool>(
  (ref) => const bool.fromEnvironment('USE_MOCK', defaultValue: true),
);

/// Shared so a failure rate raised in the debug menu applies to every mock at
/// once instead of one repository at a time.
final mockConfigProvider = Provider<MockConfig>((ref) => MockConfig());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(config: ref.watch(mockConfigProvider)),
);

final diagnosisRepositoryProvider = Provider<DiagnosisRepository>(
  (ref) => MockDiagnosisRepository(config: ref.watch(mockConfigProvider)),
);

final marketRepositoryProvider = Provider<MarketRepository>(
  (ref) => MockMarketRepository(config: ref.watch(mockConfigProvider)),
);

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => MockNewsRepository(config: ref.watch(mockConfigProvider)),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => MockWeatherRepository(config: ref.watch(mockConfigProvider)),
);
