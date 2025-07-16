import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mockito/annotations.dart';
import 'package:tracker/src/trackable.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseCrashlytics>(),
  MockSpec<FirebaseAnalytics>(),
  MockSpec<Trackable>(),
])
void main() {}
