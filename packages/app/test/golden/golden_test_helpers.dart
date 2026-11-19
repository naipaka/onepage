import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';

import '../utils/clients.dart';

abstract final class GoldenTestHelpers {
  static Future<void> expectGoldenMatches(
    WidgetTester tester,
    Widget widget,
    String goldenFile, {
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en'),
  }) async {
    final prefsClient = createPrefsClient(hapticsEnabled: true);
    final dbClient = createDbClient();

    // Set iPhone 11 size (375x812)
    await tester.binding.setSurfaceSize(const Size(375, 812));
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;

    // Set platform to iOS for consistent golden tests
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await withClock(Clock.fixed(DateTime(2025, 1, 15, 12)), () async {
      LocaleSettings.setLocaleRawSync(
        AppLocale.values
            .firstWhere((l) => l.languageCode == locale.languageCode)
            .languageTag,
      );
      await tester.pumpWidget(
        ProviderScope(
          retry: noRetry,
          overrides: [
            prefsClientProvider.overrideWithValue(prefsClient),
            dbClientProvider.overrideWithValue(dbClient),
            photoStorageProvider.overrideWithValue(
              PhotoStorage(directory: Directory.systemTemp),
            ),
            inAppReviewerProvider.overrideWith(
              (ref) async => createInAppReviewer(),
            ),
            trackerProvider.overrideWithValue(createTracker()),
            notificationClientInitializingProvider.overrideWith(
              (ref) async => createNotificationClient(),
            ),
            packageInfoProvider.overrideWithValue(
              PackageInfo(
                appName: 'OnePage',
                packageName: 'jp.co.altive.onepage',
                version: '1.0.0',
                buildNumber: '1',
              ),
            ),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              theme: appLightThemeData,
              darkTheme: appDarkThemeData,
              themeMode: themeMode,
              localizationsDelegates: localizationsDelegates,
              supportedLocales: AppLocaleUtils.supportedLocales,
              locale: locale,
              home: widget,
            ),
          ),
        ),
      );

      // Use runAsync to properly handle image loading
      await tester.runAsync(() async {
        // Find all Image widgets and precache them
        final imageFinder = find.byType(Image);
        final imageElements = imageFinder.evaluate();

        for (final element in imageElements) {
          final imageWidget = element.widget as Image;
          if (imageWidget.image is AssetImage) {
            await precacheImage(imageWidget.image, element);
          }
        }
      });

      // Ensure everything is rendered
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(goldenFile),
      );
    });

    // Reset platform override
    debugDefaultTargetPlatformOverride = null;
  }
}
