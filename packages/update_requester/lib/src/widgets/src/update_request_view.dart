import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

/// A view that shows a dialog to request an update.
class UpdateRequestView extends StatelessWidget {
  /// Creates the [UpdateRequestView].
  const UpdateRequestView({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  /// The title to show in the dialog.
  final String title;

  /// The message to show in the dialog.
  final String message;

  /// The text to show on the button.
  final String buttonText;

  /// The callback to call when the button is pressed.
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: AppText.bodyLBold(
          title,
        ),
        content: AppText.bodyM(
          message,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: onButtonPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
