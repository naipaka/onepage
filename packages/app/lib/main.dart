import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:tracker/tracker.dart';
import 'package:utils/utils.dart';

import 'adapters/adapters.dart';
import 'app.dart';
import 'environment/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: firebaseOptionsWithFlavor(Flavor.current),
  );

  final tracker = Tracker();
  await tracker.setErrorReportingEnabled(enabled: !kDebugMode);
  // Logs errors caught by the Flutter framework.
  FlutterError.onError = tracker.onFlutterError;
  // Logs uncaught asynchronous errors that the Flutter framework cannot catch.
  PlatformDispatcher.instance.onError = tracker.onPlatformError;
  // Logs errors outside the Flutter environment.
  Isolate.current.addErrorListener(tracker.isolateErrorListener());

  await LocaleSettings.useDeviceLocale();

  const providerLogPrint = String.fromEnvironment('providerLogPrint');
  runApp(
    ProviderScope(
      overrides: [trackerProvider.overrideWithValue(tracker)],
      observers: [
        ProviderLogger(
          outputLogTypes: ProviderEvent.getEventsFromNames(providerLogPrint),
          logger: logger,
        ),
        ProviderFailureReporter(
          onFailure: (error, stackTrace) =>
              unawaited(tracker.recordError(error, stackTrace)),
        ),
      ],
      retry: noRetry,
      child: TranslationProvider(child: const App()),
    ),
  );
}
