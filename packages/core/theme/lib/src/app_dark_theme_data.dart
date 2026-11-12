import 'package:material_ui/material_ui.dart';

import 'extension/extension.dart';
import 'style/style.dart';

/// Dark theme data.
ThemeData get appDarkThemeData {
  final themeData = ThemeData.dark();
  return themeData.custom(
    colorScheme: darkColorScheme,
  );
}
