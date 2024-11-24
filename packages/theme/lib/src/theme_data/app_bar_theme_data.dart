import 'package:flutter/material.dart';

import '../../theme.dart';

/// A [AppBarTheme] for the app.
AppBarTheme appBarThemeData({
  required AppTypography typography,
  required AppColors colors,
}) {
  return AppBarTheme(
    color: colors.bgMain,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: colors.textMain),
    centerTitle: true,
    titleTextStyle: typography.bodyLBold,
  );
}
