import 'package:in_app_reviewer/in_app_reviewer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_client/notification_client.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:tracker/tracker.dart';

class MockInAppReviewer extends Mock implements InAppReviewer;

class MockNotificationClient extends Mock implements NotificationClient;

class MockPrefsClient extends Mock implements PrefsClient;

class MockTracker extends Mock implements Tracker;
