import 'package:flutter/material.dart';

import '../theme_extensions/theme_extensions.dart';

/// [BuildContext] extension methods for [AppColors] and [AppTypography].
extension BuildContextWithThemeExtension on BuildContext {
  /// Retrieve the closest [AppColors] instance via [BuildContext].
  AppColors get colors => Theme.of(this).extension()!;

  /// Retrieve the closest [AppTypography] instance via [BuildContext].
  AppTypography get typography => Theme.of(this).extension()!;
}
