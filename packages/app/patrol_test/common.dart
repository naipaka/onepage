import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:meta/meta.dart';
import 'package:onepage/app.dart';
import 'package:onepage/keys.dart';
import 'package:patrol/patrol.dart';

export 'package:flutter_test/flutter_test.dart';
export 'package:onepage/keys.dart';
export 'package:patrol/patrol.dart';

/// Starts the app with the same setup as `main`.
///
/// Patrol tests mount the root widget with [PatrolIntegrationTester.pumpWidget]
/// instead of calling `runApp`, as Patrol's setup docs require.
///
/// The ready waits use a longer timeout than Patrol's default because a cold
/// simulator can spend more than 10 seconds before rendering the app shell or
/// diary data.
Future<void> createApp(PatrolIntegrationTester $) async {
  await Firebase.initializeApp();
  await LocaleSettings.useDeviceLocale();
  await $.pumpWidget(
    ProviderScope(child: TranslationProvider(child: const App())),
  );
  await $.waitUntilVisible($(K.homePage), timeout: const Duration(seconds: 30));
  await $.waitUntilVisible(
    $(K.diaryCalendar),
    timeout: const Duration(seconds: 30),
  );
}

/// Defines a Patrol integration test with the shared app test defaults.
@isTest
void patrol(
  String description,
  Future<void> Function(PatrolIntegrationTester) callback, {
  bool? skip,
  List<String> tags = const [],
}) {
  patrolTest(description, skip: skip, callback, tags: tags);
}
