import 'package:flutter/material.dart';

import '../theme_extensions/app_typography.dart';

const _notoSansJPFontFamily = 'NotoSansJP';

/// Generate [AppTypography] by specifying [textColor].
AppTypography appTypography({required Color textColor}) {
  return AppTypography(
    bodyS: TextStyle(
      fontFamily: _notoSansJPFontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      height: 14 / 12,
      color: textColor,
    ),
    bodyM: TextStyle(
      fontFamily: _notoSansJPFontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      height: 20 / 14,
      color: textColor,
    ),
    bodyL: TextStyle(
      fontFamily: _notoSansJPFontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 20,
      height: 20 / 20,
      color: textColor,
    ),
    bodySBold: TextStyle(
      fontFamily: _notoSansJPFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 12,
      height: 14 / 12,
      color: textColor,
    ),
    bodyMBold: TextStyle(
      fontFamily: _notoSansJPFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      height: 20 / 14,
      color: textColor,
    ),
    bodyLBold: TextStyle(
      fontFamily: _notoSansJPFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      height: 20 / 20,
      color: textColor,
    ),
  );
}
