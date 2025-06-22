import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utils/src/extension/src/build_context_extension.dart';

void main() {
  group('BuildContextExtension', () {
    group('unfocus', () {
      testWidgets('unfocus the focused child', (tester) async {
        final focusNode = FocusNode();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Focus(
                focusNode: focusNode,
                child: const TextField(),
              ),
            ),
          ),
        );

        // Request focus explicitly
        focusNode.requestFocus();
        await tester.pump();

        // Ensure the TextField is focused
        expect(focusNode.hasFocus, isTrue);

        // Call unfocus
        tester.element(find.byType(TextField)).unfocus();
        await tester.pump();

        // Verify that the TextField is no longer focused
        expect(focusNode.hasFocus, isFalse);
      });
    });
  });
}
