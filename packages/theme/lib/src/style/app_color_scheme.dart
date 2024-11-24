// Allow hardcoding of colors for Theme settings.
// ignore_for_file: avoid_hardcoded_color
import 'package:flutter/material.dart';

import '../theme_extensions/app_colors.dart';

/// This function takes an [AppColors] object as an argument and creates
/// a [ColorScheme]  suitable for the given [ThemeMode].
///
/// The [ColorScheme] is used to define the colors for the application's theme,
/// including primary, secondary, error, surface, and their respective on-colors
/// (colors used for text and icons on top of these colors).
///
/// Parameters:
/// - [colors] : An instance of [AppColors] which contains the color
///   definitions used to create the [ColorScheme].
///
/// Returns:
/// - A [ColorScheme] object configured with the colors provided
///   by the [AppColors] instance.
ColorScheme appColorScheme(AppColors colors) {
  return ColorScheme(
    brightness: colors.brightness,
    primary: colors.textMain!,
    onPrimary: Colors.white,
    secondary: colors.textMain!,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: colors.bgMain!,
    onSurface: colors.textMain!,
  );
}
