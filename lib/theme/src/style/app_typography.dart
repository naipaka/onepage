import 'package:flutter/material.dart';

import '../../../gen/fonts.gen.dart';
import '../theme_extensions/app_typography.dart';

/// Generate [AppTypography] by specifying [textColor].
AppTypography appTypography({required Color textColor}) {
  return AppTypography(
    bodyS: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      height: 17 / 12,
      color: textColor,
    ),
    bodyM: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      height: 20 / 14,
      color: textColor,
    ),
    bodyL: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontWeight: FontWeight.normal,
      fontSize: 20,
      height: 29 / 20,
      color: textColor,
    ),
    bodySBold: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontWeight: FontWeight.bold,
      fontSize: 12,
      height: 17 / 12,
      color: textColor,
    ),
    bodyMBold: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      height: 20 / 14,
      color: textColor,
    ),
    bodyLBold: TextStyle(
      fontFamily: FontFamily.notoSansJP,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      height: 29 / 20,
      color: textColor,
    ),
  );
}
