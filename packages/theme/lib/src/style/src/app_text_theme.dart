import 'package:flutter/material.dart';

/// M3 has five distinct type styles: Display, headline, title, body, and label.
/// https://m3.material.io/styles/typography/type-scale-tokens
const appTextTheme = TextTheme(
  titleLarge: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 24 / 20,
  ),
  titleMedium: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    height: 19 / 16,
  ),
  titleSmall: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    height: 20 / 14,
  ),
  bodyLarge: TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 19 / 16,
  ),
  bodyMedium: TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 20 / 14,
  ),
  bodySmall: TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 14 / 12,
  ),
);
