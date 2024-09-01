// ignore_for_file: avoid_hardcoded_color
import 'package:flutter/material.dart';

/// The [Color] that should be defined for each [ThemeMode] of the app.
/// Colors common to all [ThemeMode]s are defined using `getter`.
class AppColors extends ThemeExtension<AppColors> {
  /// Creates a new [AppColors] instance.
  const AppColors({
    required this.brightness,
    required this.bgMain,
    required this.textMain,
    required this.overlay,
  });

  /// The [Brightness] of the app.
  final Brightness brightness;

  /// The main background color of the app.
  final Color? bgMain;

  /// The main text color of the app.
  final Color? textMain;

  /// The overlay color of the app.
  final Color? overlay;

  @override
  AppColors copyWith({
    Brightness? brightness,
    Color? bgMain,
    Color? textMain,
    Color? overlay,
  }) {
    return AppColors(
      brightness: brightness ?? this.brightness,
      bgMain: bgMain ?? this.bgMain,
      textMain: textMain ?? this.textMain,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppColors lerp(
    AppColors? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      bgMain: Color.lerp(bgMain, other.bgMain, t),
      textMain: Color.lerp(textMain, other.textMain, t),
      overlay: Color.lerp(overlay, other.overlay, t),
    );
  }

  /// Retrieve the closest [AppColors] instance to the given [BuildContext].
  static AppColors of(BuildContext context) {
    return Theme.of(context).extension()!;
  }
}
