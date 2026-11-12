import 'package:material_ui/material_ui.dart';

import '../gen/strings.g.dart';

/// Supported locales.
List<Locale> get supportedLocales => AppLocaleUtils.supportedLocales;

/// Localizations delegates.
List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
    GlobalMaterialLocalizations.delegates;
