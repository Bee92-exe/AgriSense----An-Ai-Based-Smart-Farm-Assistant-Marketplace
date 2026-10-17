import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Both of these must complete before the first frame: settings are read
  // synchronously by the router's redirect guard, and DateFormat throws for a
  // locale whose data has not been loaded.
  final prefs = await SharedPreferences.getInstance();
  await initialiseLocalisationData();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const AgriSenseApp(),
    ),
  );
}
