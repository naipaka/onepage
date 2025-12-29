// Test helper files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:backup/backup.dart';
import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:exporter/exporter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/haptics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:in_app_reviewer/in_app_reviewer.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notification_client/notification_client.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';
import 'package:tracker/tracker.dart';

@GenerateMocks([
  PrefsClient,
  DbClient,
  BackupController,
  PdfExporter,
  CsvExporter,
  MarkdownExporter,
  Haptics,
  InAppReviewer,
  Tracker,
  NotificationClient,
])
import 'golden_test_helpers.mocks.dart';

abstract final class GoldenTestHelpers {
  static Widget wrapWithProviders({
    required Widget child,
    PrefsClient? prefsClient,
    bool mockInitialization = false,
  }) {
    final mockPrefsClient = prefsClient ?? MockPrefsClient();
    final mockDbClient = MockDbClient();
    final mockBackupController = MockBackupController();
    final mockPdfExporter = MockPdfExporter();
    final mockCsvExporter = MockCsvExporter();
    final mockMarkdownExporter = MockMarkdownExporter();
    final mockHaptics = MockHaptics();
    final mockInAppReviewer = MockInAppReviewer();
    final mockTracker = MockTracker();
    final mockNotificationClient = MockNotificationClient();

    when(mockPrefsClient.textInputHapticEnabled).thenReturn(true);
    when(mockPrefsClient.otherHapticEnabled).thenReturn(true);
    when(mockPrefsClient.notificationSettings).thenReturn([]);

    // Mock DbClient methods
    when(
      mockDbClient.getDiaries(
        from: anyNamed('from'),
        to: anyNamed('to'),
      ),
    ).thenAnswer((_) async => <Diary>[]);

    final overrides = [
      prefsClientProvider.overrideWithValue(mockPrefsClient),
      dbClientProvider.overrideWithValue(mockDbClient),
      backupControllerProvider.overrideWithValue(mockBackupController),
      pdfExporterProvider.overrideWithValue(mockPdfExporter),
      csvExporterProvider.overrideWithValue(mockCsvExporter),
      markdownExporterProvider.overrideWithValue(mockMarkdownExporter),
      hapticsProvider.overrideWithValue(mockHaptics),
      inAppReviewerProvider.overrideWith((ref) async => mockInAppReviewer),
      trackerProvider.overrideWithValue(mockTracker),
      notificationClientInitializingProvider.overrideWith(
        (ref) async => mockNotificationClient,
      ),
      packageInfoProvider.overrideWithValue(
        PackageInfo(
          appName: 'OnePage',
          packageName: 'jp.co.altive.onepage',
          version: '1.0.0',
          buildNumber: '1',
        ),
      ),
    ];

    if (mockInitialization) {
      // Mock initialization provider to return a loading state
      overrides.add(
        initializationProvider.overrideWith(
          (ref) => Future.delayed(const Duration(seconds: 10)),
        ),
      );
    }

    return ProviderScope(
      overrides: overrides,
      child: child,
    );
  }

  static Widget buildTestableWidget({
    required Widget widget,
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en'),
    PrefsClient? prefsClient,
    bool mockInitialization = false,
  }) {
    LocaleSettings.setLocaleRawSync(
      AppLocale.values
          .firstWhere((l) => l.languageCode == locale.languageCode)
          .languageTag,
    );

    return wrapWithProviders(
      prefsClient: prefsClient,
      mockInitialization: mockInitialization,
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
    );
  }

  static Future<void> expectGoldenMatches(
    WidgetTester tester,
    Widget widget,
    String goldenFile, {
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en'),
    PrefsClient? prefsClient,
    bool mockInitialization = false,
  }) async {
    // Set iPhone 11 size (375x812)
    await tester.binding.setSurfaceSize(const Size(375, 812));
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;

    // Set platform to iOS for consistent golden tests
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await withClock(Clock.fixed(DateTime(2025, 1, 15, 12)), () async {
      // First pump the widget
      await tester.pumpWidget(
        buildTestableWidget(
          widget: widget,
          themeMode: themeMode,
          locale: locale,
          prefsClient: prefsClient,
          mockInitialization: mockInitialization,
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
