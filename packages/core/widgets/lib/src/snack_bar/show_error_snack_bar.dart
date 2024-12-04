import 'package:flutter/material.dart';

import 'show_snack_bar.dart';

/// エラー用のSnackBarを表示する。
void showErrorSnackBar(
  BuildContext context, {
  required String message,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  showSnackBar(
    context,
    message: message,
    backgroundColor: colorScheme.error,
  );
}
