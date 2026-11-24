import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_reviewer/in_app_reviewer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_client/notification_client.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:tracker/tracker.dart';

import 'mock.dart';

/// Creates a [DbClient] on an in-memory database that closes after the test.
DbClient createDbClient() {
  final dbClient = createInMemoryDbClient();
  addTearDown(dbClient.close);
  return dbClient;
}

/// Creates a mock of [PrefsClient] with no notification settings.
///
/// It keeps the recent diary search terms that are set.
MockPrefsClient createPrefsClient({
  bool hapticsEnabled = false,
  bool photoRecoveryDismissed = false,
  List<String> recentDiarySearchTerms = const [],
}) {
  final prefsClient = MockPrefsClient();
  var recentTerms = recentDiarySearchTerms;
  when(() => prefsClient.recentDiarySearchTerms).thenAnswer((_) => recentTerms);
  when(() => prefsClient.setRecentDiarySearchTerms(any())).thenAnswer((
    invocation,
  ) async {
    recentTerms = invocation.positionalArguments.single as List<String>;
    return true;
  });
  when(() => prefsClient.textInputHapticEnabled).thenReturn(hapticsEnabled);
  when(() => prefsClient.otherHapticEnabled).thenReturn(hapticsEnabled);
  when(
    () => prefsClient.photoRecoveryDismissed,
  ).thenReturn(photoRecoveryDismissed);
  when(() => prefsClient.notificationSettings).thenReturn([]);
  when(
    () => prefsClient.setPhotoRecoveryDismissed(
      dismissed: any(named: 'dismissed'),
    ),
  ).thenAnswer((_) async => true);
  return prefsClient;
}

/// Creates a mock of [Tracker] that accepts every error.
MockTracker createTracker() {
  registerFallbackValue(StackTrace.empty);
  final tracker = MockTracker();
  when(
    () => tracker.recordError(any(), any()),
  ).thenAnswer((_) async {});
  return tracker;
}

/// Creates a mock of [InAppReviewer] that never asks for a review.
MockInAppReviewer createInAppReviewer() {
  final inAppReviewer = MockInAppReviewer();
  when(inAppReviewer.checkAndShowReviewIfEligible).thenAnswer((_) async {});
  return inAppReviewer;
}

/// Creates a mock of [NotificationClient] whose permission is granted and
/// that schedules nothing.
MockNotificationClient createNotificationClient() {
  registerFallbackValue(<NotificationSetting>[]);
  final notificationClient = MockNotificationClient();
  when(notificationClient.requestPermissions).thenAnswer((_) async => true);
  when(
    () => notificationClient.scheduleNotifications(
      any(),
      title: any(named: 'title'),
      message: any(named: 'message'),
    ),
  ).thenAnswer((_) async {});
  return notificationClient;
}
