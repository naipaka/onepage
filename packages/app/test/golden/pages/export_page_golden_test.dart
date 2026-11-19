@Tags(['golden'])
library;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepage/pages/pages.dart';

import '../golden_test_helpers.dart';

// The month picker lists the months of this year up to now.
final _now = DateTime(2025, 6, 15, 12);

void main() {
  group('ExportPage Golden Tests', () {
    for (final variant in GoldenVariant.values) {
      testWidgets('renders the page with ${variant.suffix}', (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const ExportPage(),
          'export_page',
          variant: variant,
          now: _now,
        );
      });

      testWidgets('renders the year picker with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const ExportPage(),
          'export_page_year_picker',
          variant: variant,
          now: _now,
          act: (tester) async {
            await tester.tap(find.byType(CupertinoButton).first);
            await tester.pumpAndSettle();
          },
        );
      });

      testWidgets('renders the month picker with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const ExportPage(),
          'export_page_month_picker',
          variant: variant,
          now: _now,
          act: (tester) async {
            await tester.tap(find.byType(CupertinoButton).last);
            await tester.pumpAndSettle();
          },
        );
      });
    }
  });
}
