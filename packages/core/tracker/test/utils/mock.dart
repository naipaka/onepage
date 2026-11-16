import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracker/src/trackable.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics;

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics;

class MockTrackable extends Mock implements Trackable;
