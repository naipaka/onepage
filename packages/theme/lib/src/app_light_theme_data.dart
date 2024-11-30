import 'package:flutter/material.dart';

import 'extension/extension.dart';
import 'style/style.dart';

/// Light theme data.
ThemeData get appLightThemeData {
  final themeData = ThemeData.light();
  final textTheme = themeData.textTheme.merge(appTextTheme);
  return themeData.custom(
    colorScheme: lightColorScheme,
    textTheme: textTheme,
  );
}
