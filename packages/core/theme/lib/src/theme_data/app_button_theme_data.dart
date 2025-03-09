import 'package:flutter/material.dart';

/// A [FilledButtonThemeData] for the app.
FilledButtonThemeData appFilledButtonThemeData({
  required ColorScheme colorScheme,
  required TextTheme textTheme,
}) =>
    FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(248, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
