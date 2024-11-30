import 'package:flutter/material.dart';

/// [BuildContext] extension methods for [ColorScheme] and [TextTheme].
extension BuildContextWithThemeExtension on BuildContext {
  /// Get the closest [TextTheme] instance via [BuildContext].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get the closest [ColorScheme] instance via [BuildContext].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
