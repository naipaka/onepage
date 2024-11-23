// Allow hardcoding of colors for Theme settings.
// ignore_for_file: avoid_hardcoded_color
import 'package:flutter/material.dart';

import '../theme_extensions/app_colors.dart';

/// [AppColors] を引数にとって、 [ThemeMode] に適した [ColorScheme]を作成するための関数
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
