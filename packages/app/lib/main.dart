import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:utils/utils.dart';

import 'adapters/adapters.dart';
import 'app.dart';
import 'environment/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: firebaseOptionsWithFlavor(Flavor.current),
  );

  const providerLogPrint = String.fromEnvironment('providerLogPrint');
  final container = ProviderContainer(
    observers: [
      ProviderLogger(
        outputLogTypes: ProviderEvent.getEventsFromNames(providerLogPrint),
        logger: logger,
      ),
    ],
  );

  final tracker = container.read(trackerProvider);
  // Logs errors caught by the Flutter framework.
  FlutterError.onError = tracker.onFlutterError;
  // Logs uncaught asynchronous errors that the Flutter framework cannot catch.
  PlatformDispatcher.instance.onError = tracker.onPlatformError;
  // Logs errors outside the Flutter environment.
  Isolate.current.addErrorListener(tracker.isolateErrorListener());

  await LocaleSettings.useDeviceLocale();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: TranslationProvider(child: const App()),
    ),
  );
}
