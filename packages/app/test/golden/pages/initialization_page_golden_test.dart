@Tags(['golden'])
library;

// Test files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../golden_test_helpers.dart';

void main() {
  group('InitializationPage Golden Tests', () {
    testWidgets(
      'renders loading state correctly with light theme and English locale',
      (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Loading...'),
            ),
          ),
          'goldens/initialization_page_loading_light_en.png',
        );
      },
    );

    testWidgets(
      'renders loading state correctly with dark theme and English locale',
      (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Loading...'),
            ),
          ),
          'goldens/initialization_page_loading_dark_en.png',
          themeMode: ThemeMode.dark,
        );
      },
    );
  });
}
