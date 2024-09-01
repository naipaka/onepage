import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension L10n on AppLocalizations {
  /// `L10n.of(context)`
  ///
  /// This implementation solves two problems of `AppLocalizations.of(context)`:
  /// 1. It is not suggested by the IDE (not auto-imported).
  /// 2. The obtained AppLocalizations is nullable.
  /// This alternative method addresses both issues.
  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;
}

extension BuildContextL10n on BuildContext {
  /// `context.l10n`
  AppLocalizations get l10n => L10n.of(this);
}
