import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme_data/theme_data.dart';

/// Provides a set of extensions for [ThemeData].
extension ThemeDataExtension on ThemeData {
  /// Returns a copy of this [ThemeData] with the given fields replaced by the
  /// new values.
  ThemeData custom({
    required ColorScheme colorScheme,
  }) {
    return copyWith(
      // 🎨 Color scheme section
      colorScheme: colorScheme,
      dialogBackgroundColor: colorScheme.scrim,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      // 🖋 Text theme section
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      // 🖼 ThemeData section
      appBarTheme: appBarThemeData(
        colorScheme: colorScheme,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: const CircleBorder(),
        foregroundColor: colorScheme.onPrimary,
      ),
      // Workaround for: CupertinoTextInputDialog input text color and
      // background color are the same.
      // https://pub.dev/packages/adaptive_dialog#the-input-text-color-same-with-backgound-when-using-cupertinotextinputdialog
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
    );
  }
}
