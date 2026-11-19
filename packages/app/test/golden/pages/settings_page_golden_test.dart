@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:onepage/pages/pages.dart';

import '../golden_test_helpers.dart';

void main() {
  group('SettingsPage Golden Tests', () {
    for (final variant in GoldenVariant.values) {
      testWidgets('renders the page with ${variant.suffix}', (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const SettingsPage(),
          'settings_page',
          variant: variant,
        );
      });
    }
  });
}
