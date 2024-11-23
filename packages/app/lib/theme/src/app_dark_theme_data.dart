// ignore_for_file: avoid_hardcoded_color
import 'package:flutter/material.dart';

import 'extension/extension.dart';
import 'style/style.dart';
import 'theme_extensions/theme_extensions.dart';

/// Dark theme data.
ThemeData get appDarkThemeData {
  const colors = AppColors(
    brightness: Brightness.dark,
    bgMain: Color(0xFF4F4F4F),
    textMain: Color(0xFFEDEDED),
    overlay: Colors.black38,
  );

  final typography = appTypography(textColor: colors.textMain!);

  final colorScheme = appColorScheme(colors);

  final themeData = ThemeData.dark();

  return themeData.custom(
    colorScheme: colorScheme,
    colors: colors,
    typography: typography,
  );
}
