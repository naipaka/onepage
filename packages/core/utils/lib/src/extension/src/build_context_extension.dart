import 'package:flutter/material.dart';

/// An extension on [BuildContext] to provide utility methods.
extension BuildContextExtension on BuildContext {
  /// Unfocus the current focused child and dismiss the keyboard.
  void unfocus() {
    // Unfocus the current focused child and dismiss the keyboard.
    FocusScope.of(this).focusedChild?.unfocus();
    // Fallback to unfocusing the current focus scope.
    FocusScope.of(this).unfocus();
  }
}
