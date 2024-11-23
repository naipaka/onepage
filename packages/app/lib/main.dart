import 'dart:isolate';
import 'dart:ui';

import 'package:altfire_configurator/altfire_configurator.dart';
import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'adapters/configurator_provider.dart';
import 'adapters/tracker_provider.dart';
import 'app.dart';
import 'environment/environment.dart';
import 'features/update_request/update_request.dart';
import 'gen/strings.g.dart';
import 'providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavor = Flavor.values.byName(const String.fromEnvironment('flavor'));

  await Firebase.initializeApp(options: firebaseOptionsWithFlavor(flavor));

  final (configurator, packageInfo, _) = await (
    _initializeConfigurator(),
    PackageInfo.fromPlatform(),
    LocaleSettings.useDeviceLocale(),
  ).wait;

  final tracker = Tracker();
  // Logs errors caught by the Flutter framework.
  FlutterError.onError = tracker.onFlutterError;
  // Logs uncaught asynchronous errors that the Flutter framework cannot catch.
  PlatformDispatcher.instance.onError = tracker.onPlatformError;
  // Logs errors outside the Flutter environment.
  Isolate.current.addErrorListener(tracker.isolateErrorListener());

  runApp(
    ProviderScope(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        configuratorProvider.overrideWithValue(configurator),
        trackerProvider.overrideWithValue(tracker),
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      child: TranslationProvider(
        child: const App(),
      ),
    ),
  );
}

/// Initializes the process to retrieve values from RemoteConfig.
Future<Configurator> _initializeConfigurator() async {
  final target = Configurator();
  await target.fetchAndActivate();
  // Sets default values to be used when the app is offline or
  // cannot fetch updates.
  await target.setDefaults({
    updateRequestKey: updateRequestDefaultValue,
  });
  return target;
}
