import 'package:flutter/material.dart';

/// A [AppBarTheme] for the app.
AppBarTheme appBarThemeData({
  required ColorScheme colorScheme,
}) {
  return AppBarTheme(
    color: colorScheme.surface,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: colorScheme.onSurface),
    centerTitle: true,
  );
}
