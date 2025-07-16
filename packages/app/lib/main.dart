import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:tracker/tracker.dart';
import 'package:utils/utils.dart';

import 'adapters/adapters.dart';
import 'app.dart';
import 'environment/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavor = Flavor.values.byName(const String.fromEnvironment('flavor'));

  await Firebase.initializeApp(options: firebaseOptionsWithFlavor(flavor));

  final tracker = Tracker();
  // Logs errors caught by the Flutter framework.
  FlutterError.onError = tracker.onFlutterError;
  // Logs uncaught asynchronous errors that the Flutter framework cannot catch.
  PlatformDispatcher.instance.onError = tracker.onPlatformError;
  // Logs errors outside the Flutter environment.
  Isolate.current.addErrorListener(tracker.isolateErrorListener());

  // Initialize locale and preferences concurrently
  final (_, prefsClient) = await (
    LocaleSettings.useDeviceLocale(),
    PrefsClient.initialize(),
  ).wait;

  const providerLogPrint = String.fromEnvironment('providerLogPrint');
  final outputLogTypes = ProviderEvent.getEventsFromNames(providerLogPrint);
  final providerLogger = ProviderLogger(
    outputLogTypes: outputLogTypes,
    logger: logger,
  );

  runApp(
    ProviderScope(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        trackerProvider.overrideWithValue(tracker),
        prefsClientProvider.overrideWithValue(prefsClient),
      ],
      observers: [providerLogger],
      child: TranslationProvider(
        child: const App(),
      ),
    ),
  );
}
