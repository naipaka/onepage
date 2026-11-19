@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_client/notification_client.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';
import 'package:prefs_client/prefs_client.dart';

import '../../utils/clients.dart';
import '../golden_test_helpers.dart';

/// Creates a [PrefsClient] that has a notification at each of [hours], the
/// second of which is off.
PrefsClient _prefsClient(List<int> hours) {
  final prefsClient = createPrefsClient(hapticsEnabled: true);
  when(() => prefsClient.notificationSettings).thenReturn([
    for (final (index, hour) in hours.indexed)
      NotificationSetting(
        id: index + 1,
        hour: hour,
        isEnabled: index != 1,
      ).toJson(),
  ]);
  return prefsClient;
}

void main() {
  group('NotificationsPage Golden Tests', () {
    for (final variant in GoldenVariant.values) {
      testWidgets('renders the most notifications with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const NotificationsPage(),
          'notifications_page',
          variant: variant,
          prefsClient: _prefsClient([7, 13, 21]),
        );
      });

      testWidgets('renders a denied permission with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const NotificationsPage(),
          'notifications_page_denied',
          variant: variant,
          prefsClient: _prefsClient([7, 21]),
          overrides: [
            notificationPermissionGrantedProvider.overrideWith(
              (ref) async => false,
            ),
          ],
        );
      });

      testWidgets('renders the time picker with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const NotificationsPage(),
          'notifications_page_time_picker',
          variant: variant,
          prefsClient: _prefsClient([7, 13, 21]),
          act: (tester) async {
            await tester.tap(find.text('07:00'));
            await tester.pumpAndSettle();
          },
        );
      });
    }
  });
}
