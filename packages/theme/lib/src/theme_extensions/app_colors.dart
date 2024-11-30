// Allow hardcoding of colors for Theme settings.
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

  /// Brand color used in the app.
  Color get primary => const Color(0xFFFF6F00);

  /// Foreground color on the primary color.
  Color get onPrimary => const Color(0xFFFFFFFF);

  /// Error color used in the app.
  Color get error => const Color(0xFFB00020);

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
