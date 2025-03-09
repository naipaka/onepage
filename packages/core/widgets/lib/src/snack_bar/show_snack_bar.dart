import 'package:flutter/material.dart';

/// Display a SnackBar.
void showSnackBar(
  BuildContext context, {
  required String message,
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
    ),
  );
}
