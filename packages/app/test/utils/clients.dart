import 'package:db_client/db_client.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_reviewer/in_app_reviewer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_client/notification_client.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/tracker.dart';

import 'mock.dart';

/// Creates a [DbClient] on an in-memory database that closes after the test.
DbClient createDbClient() {
  final dbClient = DbClient.forTesting(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  addTearDown(dbClient.close);
  return dbClient;
}

/// Creates a [PrefsClient] whose preferences start with [values].
Future<PrefsClient> createPrefsClient([
  Map<String, Object> values = const {},
]) {
  SharedPreferences.setMockInitialValues(values);
  return PrefsClient.initialize();
}

/// Creates a [Tracker] that sends to [crashlytics] and a mock of Analytics.
Tracker createTracker(MockFirebaseCrashlytics crashlytics) {
  when(
    () => crashlytics.recordError(
      any<Object?>(),
      any(),
      fatal: any(named: 'fatal'),
    ),
  ).thenAnswer((_) async {});
  return Tracker.forTesting(
    crashlytics: crashlytics,
    analytics: MockFirebaseAnalytics(),
  );
}

/// Creates an [InAppReviewer] whose store review is not available.
InAppReviewer createInAppReviewer(PrefsClient prefsClient) {
  final inAppReview = MockInAppReview();
  when(inAppReview.isAvailable).thenAnswer((_) async => false);
  return InAppReviewer(
    isEligible: false,
    prefsClient: prefsClient,
    inAppReview: inAppReview,
  );
}

/// Creates a [NotificationClient] whose iOS notification permission is
/// granted and that schedules nothing.
NotificationClient createNotificationClient() {
  final plugin = MockFlutterLocalNotificationsPlugin();
  final iosPlugin = MockIOSFlutterLocalNotificationsPlugin();
  when(plugin.cancelAll).thenAnswer((_) async {});
  when(
    () => plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >(),
  ).thenReturn(iosPlugin);
  when(
    () => iosPlugin.requestPermissions(
      alert: any(named: 'alert'),
      badge: any(named: 'badge'),
      sound: any(named: 'sound'),
    ),
  ).thenAnswer((_) async => true);
  return NotificationClient.forTesting(
    notificationsPlugin: plugin,
    channelName: 'Channel',
    channelDescription: 'Description',
  );
}

/// Adds a diary image that refers to [photoId] in the device's photo library.
Future<DiaryImage> insertExternalDiaryImage(
  DbClient dbClient, {
  required int diaryId,
  required String photoId,
}) {
  return dbClient
      .into(dbClient.diaryImages)
      .insertReturning(
        DiaryImagesCompanion.insert(
          diaryId: diaryId,
          photoId: Value(photoId),
        ),
      );
}
