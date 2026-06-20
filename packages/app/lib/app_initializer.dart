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

/// {@template onepage.AppInitializer}
/// Initializes dependencies and builds the app widget tree.
///
/// Shared between [main] and patrol tests. Does not call
/// [WidgetsFlutterBinding.ensureInitialized], [runApp], or set up
/// error handlers — those are the caller's responsibility.
/// {@endtemplate}
class AppInitializer {
  /// {@macro onepage.AppInitializer}
  const AppInitializer._();

  /// Initializes async dependencies and returns the root widget.
  static Future<Widget> createApp({Tracker? tracker}) async {
    final flavor = Flavor.values.byName(const String.fromEnvironment('flavor'));

    // The default app is auto-initialized natively from the bundled
    // GoogleService-Info.plist (iOS) / google-services.json (Android), which are
    // selected per flavor at build time. Initialize without explicit options to
    // avoid a duplicate [DEFAULT] app.
    await Firebase.initializeApp();

    final effectiveTracker = tracker ?? Tracker();

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

    return ProviderScope(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        trackerProvider.overrideWithValue(effectiveTracker),
        prefsClientProvider.overrideWithValue(prefsClient),
      ],
      observers: [providerLogger],
      child: TranslationProvider(child: const App()),
    );
  }
}
