import 'package:flutter/material.dart';

/// Displays a snack bar with one action.
///
/// The snack bar stays until the user acts on it or dismisses it.
void showActionSnackBar(
  BuildContext context, {
  required String message,
  required String actionLabel,
  required VoidCallback onAction,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(label: actionLabel, onPressed: onAction),
    ),
  );
}
