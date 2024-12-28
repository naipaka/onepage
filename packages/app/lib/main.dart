import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:provider_utils/provider_utils.dart';
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

  // Set the locale to the device's locale.
  await LocaleSettings.useDeviceLocale();

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
      ],
      observers: [providerLogger],
      child: TranslationProvider(
        child: const App(),
      ),
    ),
  );
}
