import 'package:flutter/material.dart';

/// Provides the [TextStyle] that should be defined
/// for each [ThemeMode] of the app.
class AppTypography extends ThemeExtension<AppTypography> {
  /// Creates a new [AppTypography] instance.
  const AppTypography({
    required this.bodyS,
    required this.bodyM,
    required this.bodyL,
    required this.bodySBold,
    required this.bodyMBold,
    required this.bodyLBold,
  });

  /// The [TextStyle] for the smallest body text.
  final TextStyle? bodyS;

  /// The [TextStyle] for the medium body text.
  final TextStyle? bodyM;

  /// The [TextStyle] for the largest body text.
  final TextStyle? bodyL;

  /// The [TextStyle] for the smallest bold body text.
  final TextStyle? bodySBold;

  /// The [TextStyle] for the medium bold body text.
  final TextStyle? bodyMBold;

  /// The [TextStyle] for the largest bold body text.
  final TextStyle? bodyLBold;

  @override
  AppTypography copyWith({
    TextStyle? bodyS,
    TextStyle? bodyM,
    TextStyle? bodyL,
    TextStyle? bodySBold,
    TextStyle? bodyMBold,
    TextStyle? bodyLBold,
  }) {
    return AppTypography(
      bodyS: bodyS ?? this.bodyS,
      bodyM: bodyM ?? this.bodyM,
      bodyL: bodyL ?? this.bodyL,
      bodySBold: bodySBold ?? this.bodySBold,
      bodyMBold: bodyMBold ?? this.bodyMBold,
      bodyLBold: bodyLBold ?? this.bodyLBold,
    );
  }

  @override
  AppTypography lerp(
    AppTypography? other,
    double t,
  ) {
    if (other is! AppTypography) {
      return this;
    }
    return AppTypography(
      bodyS: TextStyle.lerp(bodyS, other.bodyS, t),
      bodyM: TextStyle.lerp(bodyM, other.bodyM, t),
      bodyL: TextStyle.lerp(bodyL, other.bodyL, t),
      bodySBold: TextStyle.lerp(bodySBold, other.bodySBold, t),
      bodyMBold: TextStyle.lerp(bodyMBold, other.bodyMBold, t),
      bodyLBold: TextStyle.lerp(bodyLBold, other.bodyLBold, t),
    );
  }

  /// Retrieve the closest [AppTypography] instance to the given [BuildContext].
  static AppTypography of(BuildContext context) {
    return Theme.of(context).extension()!;
  }
}
