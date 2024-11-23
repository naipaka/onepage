import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:altfire_configurator/altfire_configurator.dart';
import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:update_requester/update_requester.dart';
import 'package:utils/utils.dart';

import 'adapters/configurator_provider.dart';
import 'adapters/tracker_provider.dart';
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

  final (configurator, packageInfo, _) = await (
    _initializeConfigurator(tracker: tracker),
    PackageInfo.fromPlatform(),
    LocaleSettings.useDeviceLocale(),
  ).wait;

  runApp(
    ProviderScope(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        configuratorProvider.overrideWithValue(configurator),
        trackerProvider.overrideWithValue(tracker),
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      observers: [ProviderLogger()],
      child: TranslationProvider(
        child: const App(),
      ),
    ),
  );
}

/// Initializes the process to retrieve values from RemoteConfig.
Future<Configurator> _initializeConfigurator({
  required Tracker tracker,
}) async {
  final target = Configurator();
  try {
    await target.fetchAndActivate();
  } on Exception catch (e) {
    logger.severe('Failed to fetch and activate remote config: $e');
    unawaited(tracker.recordError(e, StackTrace.current));
  }
  // Sets default values to be used when the app is offline or
  // cannot fetch updates.
  await target.setDefaults({
    updateRequestKey: updateRequestDefaultValue,
  });
  return target;
}
