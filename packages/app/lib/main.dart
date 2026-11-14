import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:tracker/tracker.dart';
import 'package:utils/utils.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Passing options would duplicate the [DEFAULT] app that is already
  // configured natively from the per-flavor GoogleService-Info.plist /
  // google-services.json.
  await Firebase.initializeApp();

  final tracker = Tracker();
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
      observers: [
        ProviderLogger(
          outputLogTypes: ProviderEvent.getEventsFromNames(providerLogPrint),
          logger: logger,
        ),
      ],
      child: TranslationProvider(child: const App()),
    ),
  );
}
