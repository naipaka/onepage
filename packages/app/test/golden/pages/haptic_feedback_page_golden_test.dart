@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepage/pages/pages.dart';

import '../../utils/clients.dart';
import '../golden_test_helpers.dart';

void main() {
  group('HapticFeedbackPage Golden Tests', () {
    for (final variant in GoldenVariant.values) {
      testWidgets(
        'renders a switch that is on and one that is off with '
        '${variant.suffix}',
        (tester) async {
          final prefsClient = createPrefsClient(hapticsEnabled: true);
          when(() => prefsClient.otherHapticEnabled).thenReturn(false);

          await GoldenTestHelpers.expectGoldenMatches(
            tester,
            const HapticFeedbackPage(),
            'haptic_feedback_page',
            variant: variant,
            prefsClient: prefsClient,
          );
        },
      );
    }
  });
}
