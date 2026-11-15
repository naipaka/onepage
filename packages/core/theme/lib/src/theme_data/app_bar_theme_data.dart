import 'package:material_ui/material_ui.dart';

/// An [AppBarThemeData] for the app.
AppBarThemeData appBarThemeData({
  required ColorScheme colorScheme,
}) {
  return AppBarThemeData(
    backgroundColor: colorScheme.surface,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: colorScheme.onSurface),
    centerTitle: true,
  );
}
