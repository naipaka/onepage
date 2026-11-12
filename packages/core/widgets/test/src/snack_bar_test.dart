import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgets/widgets.dart';

void main() {
  group('showActionSnackBar', () {
    testWidgets('runs the action when it is tapped', (tester) async {
      var acted = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showActionSnackBar(
                  context,
                  message: 'message',
                  actionLabel: 'action',
                  onAction: () => acted++,
                ),
                child: const Text('show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 10));

      expect(find.text('message'), findsOneWidget);

      await tester.tap(find.text('action'));
      await tester.pumpAndSettle();

      expect(acted, 1);
      expect(find.text('message'), findsNothing);
    });
  });
}
