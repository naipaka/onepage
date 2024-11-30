import 'package:flutter/material.dart';

import 'extension/extension.dart';
import 'style/style.dart';

/// Dark theme data.
ThemeData get appDarkThemeData {
  final themeData = ThemeData.dark();
  final textTheme = themeData.textTheme.merge(appTextTheme);
  return themeData.custom(
    colorScheme: darkColorScheme,
    textTheme: textTheme,
  );
}
