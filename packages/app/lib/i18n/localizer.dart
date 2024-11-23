import 'package:flutter/widgets.dart';

import '../gen/strings.g.dart';

/// [BuildContext] extension to access translations.
extension BuildContextI18n on BuildContext {
  /// `context.l10n`
  Translations get t => Translations.of(this);
}
