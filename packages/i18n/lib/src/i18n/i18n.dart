import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../gen/strings.g.dart';

/// Supported locales.
List<Locale> get supportedLocales => AppLocaleUtils.supportedLocales;

/// Localizations delegates.
List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
    GlobalMaterialLocalizations.delegates;
