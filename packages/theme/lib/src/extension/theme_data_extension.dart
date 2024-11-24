import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme_data/theme_data.dart';
import '../theme_extensions/theme_extensions.dart';

/// Provides a set of extensions for [ThemeData].
extension ThemeDataExtension on ThemeData {
  /// Creates a copy of this [ThemeData] but with the given fields replaced with
  /// the new values.
  ThemeData custom({
    required ColorScheme colorScheme,
    required AppColors colors,
    required AppTypography typography,
  }) {
    return copyWith(
      // 🎨 Color scheme section
      colorScheme: colorScheme,
      dialogBackgroundColor: colors.overlay,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colors.bgMain,
      // 🖋 Text theme section
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      // 🖼 ThemeData section
      appBarTheme: appBarThemeData(
        typography: typography,
        colors: colors,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: const CircleBorder(),
        foregroundColor: colorScheme.onPrimary,
      ),
      extensions: [
        colors,
        typography,
      ],
      // Workaround for: CupertinoTextInputDialog input text color and
      // background color are the same.
      // https://pub.dev/packages/adaptive_dialog#the-input-text-color-same-with-backgound-when-using-cupertinotextinputdialog
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
    );
  }
}
