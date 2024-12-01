import 'package:flutter/material.dart';

/// SnackBarを表示する。
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
