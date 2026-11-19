import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';
import 'package:provider_utils/provider_utils.dart';

import '../utils/clients.dart';

void main() {
  group('InitializationPage', () {
    testWidgets('shows a failed start and initializes again on retry', (
      tester,
    ) async {
      LocaleSettings.setLocaleRawSync('en');
      var failing = true;

      await tester.pumpWidget(
        ProviderScope(
          retry: noRetry,
          overrides: [
            prefsClientProvider.overrideWithValue(createPrefsClient()),
            initializationProvider.overrideWith((ref) async {
              if (failing) {
                throw Exception('failed');
              }
            }),
            updateRequestMessageProvider.overrideWithValue(null),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              localizationsDelegates: localizationsDelegates,
              supportedLocales: AppLocaleUtils.supportedLocales,
              locale: const Locale('en'),
              home: InitializationPage(onInitialized: (_) => null),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Could not start the app'), findsOneWidget);

      failing = false;
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Could not start the app'), findsNothing);
      expect(find.text('Retry'), findsNothing);
    });
  });
}
