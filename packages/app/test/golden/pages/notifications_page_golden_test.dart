import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepage/pages/pages.dart';

import '../golden_test_helpers.dart';

void main() {
  group('NotificationsPage Golden Tests', () {
    testWidgets(
      'renders correctly with light theme and English locale',
      (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const NotificationsPage(),
          'goldens/notifications_page_light_en.png',
        );
      },
    );

    testWidgets(
      'renders correctly with dark theme and English locale',
      (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const NotificationsPage(),
          'goldens/notifications_page_dark_en.png',
          themeMode: ThemeMode.dark,
        );
      },
    );
  });
}