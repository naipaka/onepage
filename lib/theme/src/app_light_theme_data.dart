// ignore_for_file: avoid_hardcoded_color
import 'package:flutter/material.dart';

import 'extension/extension.dart';
import 'style/style.dart';
import 'theme_extensions/theme_extensions.dart';

/// Light theme data.
ThemeData get appLightThemeData {
  const colors = AppColors(
    brightness: Brightness.light,
    bgMain: Color(0xFFEDEDED),
    textMain: Color(0xFF4F4F4F),
    overlay: Colors.black54,
  );

  final typography = appTypography(textColor: colors.textMain!);

  final colorScheme = appColorScheme(colors);

  final themeData = ThemeData.light();

  return themeData.custom(
    colorScheme: colorScheme,
    colors: colors,
    typography: typography,
  );
}
