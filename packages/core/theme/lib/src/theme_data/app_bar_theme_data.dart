import 'package:material_ui/material_ui.dart';

/// A [AppBarTheme] for the app.
AppBarTheme appBarThemeData({
  required ColorScheme colorScheme,
}) {
  return AppBarTheme(
    backgroundColor: colorScheme.surface,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: colorScheme.onSurface),
    centerTitle: true,
  );
}
