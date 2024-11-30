import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:update_requester/src/widgets/src/update_request_view.dart';

void main() {
  group('UpdateRequestView', () {
    testWidgets('should display the title', (tester) async {
      const title = 'Update Available';
      const message = 'Update available!';
      const buttonText = 'Update Now';
      await tester.pumpWidget(
        _TestApp(
          title: title,
          message: message,
          buttonText: buttonText,
          onButtonPressed: () {},
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should display the update message', (tester) async {
      const title = 'Update Available';
      const message = 'Update available!';
      const buttonText = 'Update Now';
      await tester.pumpWidget(
        _TestApp(
          message: message,
          title: title,
          buttonText: buttonText,
          onButtonPressed: () {},
        ),
      );

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('should display the update button', (tester) async {
      const title = 'Update Available';
      const message = 'Update available!';
      const buttonText = 'Update Now';
      await tester.pumpWidget(
        _TestApp(
          title: title,
          message: message,
          buttonText: buttonText,
          onButtonPressed: () {},
        ),
      );

      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should call onButtonPressed when update button is pressed',
        (tester) async {
      const title = 'Update Available';
      const message = 'Update available!';
      const buttonText = 'Update Now';
      var buttonPressed = false;
      void onButtonPressed() {
        buttonPressed = true;
      }

      await tester.pumpWidget(
        _TestApp(
          title: title,
          message: message,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
        ),
      );

      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      expect(buttonPressed, isTrue);
    });
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: UpdateRequestView(
          title: title,
          message: message,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
        ),
      ),
    );
  }
}
