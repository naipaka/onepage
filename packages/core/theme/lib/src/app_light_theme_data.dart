import 'package:flutter/material.dart';

import 'extension/extension.dart';
import 'style/style.dart';

/// Light theme data.
ThemeData get appLightThemeData {
  final themeData = ThemeData.light();
  return themeData.custom(
    colorScheme: lightColorScheme,
  );
}
