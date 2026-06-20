import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:onepage/app_initializer.dart';
import 'package:onepage/keys.dart';
import 'package:patrol/patrol.dart';

export 'package:flutter_test/flutter_test.dart';
export 'package:onepage/keys.dart';
export 'package:patrol/patrol.dart';

/// Starts the app with the same initialization path as production.
///
/// Patrol tests must not call `runApp`. The root widget is created by
/// [AppInitializer.createApp] and mounted with [PatrolIntegrationTester.pumpWidget].
///
/// [K.homePage] confirms that app initialization completed. [K.diaryCalendar]
/// confirms that diary data was loaded and the main content was rendered.
///
/// The ready waits use a longer timeout than Patrol's default because a cold
/// simulator can spend more than 10 seconds before rendering the app shell or
/// diary data.
Future<void> createApp(PatrolIntegrationTester $) async {
  final app = await AppInitializer.createApp();
  await $.pumpWidget(app);
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
