import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:tracker/tracker.dart';
import 'package:utils/utils.dart';

import 'adapters/adapters.dart';
import 'app.dart';
import 'environment/environment.dart';

/// {@template onepage.AppInitializer}
/// Initializes dependencies and builds the app widget tree.
/// {@endtemplate}
class AppInitializer {
  /// {@macro onepage.AppInitializer}
  const new _();

  /// Initializes the default Firebase app.
  static Future<void> initializeFirebase() async {
    // Passing options would duplicate the [DEFAULT] app that is already
    // configured natively from the per-flavor GoogleService-Info.plist /
    // google-services.json.
    await Firebase.initializeApp();
  }

  /// Initializes async dependencies and returns the root widget.
  static Future<Widget> createApp({Tracker? tracker}) async {
    final flavor = Flavor.values.byName(const String.fromEnvironment('flavor'));

    final effectiveTracker = tracker ?? Tracker();

    final (_, prefsClient, photoStorage) = await (
      LocaleSettings.useDeviceLocale(),
      PrefsClient.initialize(),
      PhotoStorage.create(),
    ).wait;

    const providerLogPrint = String.fromEnvironment('providerLogPrint');
    final outputLogTypes = ProviderEvent.getEventsFromNames(providerLogPrint);
    final providerLogger = ProviderLogger(
      outputLogTypes: outputLogTypes,
      logger: logger,
    );

    return ProviderScope(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        trackerProvider.overrideWithValue(effectiveTracker),
        prefsClientProvider.overrideWithValue(prefsClient),
        photoStorageProvider.overrideWithValue(photoStorage),
      ],
      observers: [providerLogger],
      child: TranslationProvider(child: const App()),
    );
  }
}
