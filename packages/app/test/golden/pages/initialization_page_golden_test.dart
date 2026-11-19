@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';

import '../golden_fakes.dart';
import '../golden_test_helpers.dart';

void main() {
  group('InitializationPage Golden Tests', () {
    for (final variant in GoldenVariant.values) {
      testWidgets('renders a failed start with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          InitializationPage(onInitialized: (_) => null),
          'initialization_page_error',
          variant: variant,
          overrides: [
            initializationProvider.overrideWith(
              (ref) => Future.error(Exception('failed')),
            ),
          ],
        );
      });

      testWidgets('renders an update request with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          InitializationPage(onInitialized: (_) => const HomePage()),
          'initialization_page_update_request',
          variant: variant,
          overrides: [
            initializationProvider.overrideWith((ref) async {}),
            devicePhotosProvider.overrideWithValue(FakeDevicePhotos()),
            photoRecoveryCommandProvider.overrideWithValue(
              FakePhotoRecoveryCommand(),
            ),
            updateRequestMessageProvider.overrideWithValue(
              switch (variant.locale.languageCode) {
                'ja' => '新しいバージョンを公開しました。アップデートしてからお使いください。',
                _ => 'A new version is available. Please update the app.',
              },
            ),
          ],
        );
      });
    }
  });
}
