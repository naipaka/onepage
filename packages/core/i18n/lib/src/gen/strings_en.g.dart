///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	// Translations
	@override String get title => 'One Page';
	@override String get organization => 'NPK Studio';
	@override late final _TranslationsUpdateRequestEn updateRequest = _TranslationsUpdateRequestEn._(_root);
	@override late final _TranslationsHomeEn home = _TranslationsHomeEn._(_root);
	@override late final _TranslationsBackupEn backup = _TranslationsBackupEn._(_root);
}

// Path: updateRequest
class _TranslationsUpdateRequestEn implements TranslationsUpdateRequestJa {
	_TranslationsUpdateRequestEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Update Request';
	@override late final _TranslationsUpdateRequestButtonEn button = _TranslationsUpdateRequestButtonEn._(_root);
}

// Path: home
class _TranslationsHomeEn implements TranslationsHomeJa {
	_TranslationsHomeEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Home';
	@override String get license => 'License';
	@override String get backup => 'Backup';
	@override String get errorSavingDiary => 'An error occurred while saving your diary';
	@override String get errorSavingDiarySolution => 'We apologize, but please copy your text and restart the app';
}

// Path: backup
class _TranslationsBackupEn implements TranslationsBackupJa {
	_TranslationsBackupEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Backup';
	@override String get description => 'Backup for a Smooth Device Switch';
	@override String get explanation => 'Easily generate a backup file and save it wherever you prefer (e.g., iCloud, Google Drive, etc.).';
	@override String get restoreExplanation => 'Simply select the saved backup file to restore your data.\nPlease note: Restoring will overwrite your current data.';
	@override String get successMessage => 'Backup created successfully!';
	@override String get failedMessage => 'Failed to create backup';
	@override String get restoreFailedMessage => 'Failed to restore backup';
	@override String get restoreSuccess => 'Restoring your backup was successful';
	@override late final _TranslationsBackupActionsEn actions = _TranslationsBackupActionsEn._(_root);
}

// Path: updateRequest.button
class _TranslationsUpdateRequestButtonEn implements TranslationsUpdateRequestButtonJa {
	_TranslationsUpdateRequestButtonEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get updateNow => 'Update Now';
}

// Path: backup.actions
class _TranslationsBackupActionsEn implements TranslationsBackupActionsJa {
	_TranslationsBackupActionsEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get create => 'Create Backup';
	@override String get restore => 'Restore Backup';
	@override String get goToHome => 'Go to Home';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'title': return 'One Page';
			case 'organization': return 'NPK Studio';
			case 'updateRequest.title': return 'Update Request';
			case 'updateRequest.button.updateNow': return 'Update Now';
			case 'home.title': return 'Home';
			case 'home.license': return 'License';
			case 'home.backup': return 'Backup';
			case 'home.errorSavingDiary': return 'An error occurred while saving your diary';
			case 'home.errorSavingDiarySolution': return 'We apologize, but please copy your text and restart the app';
			case 'backup.title': return 'Backup';
			case 'backup.description': return 'Backup for a Smooth Device Switch';
			case 'backup.explanation': return 'Easily generate a backup file and save it wherever you prefer (e.g., iCloud, Google Drive, etc.).';
			case 'backup.restoreExplanation': return 'Simply select the saved backup file to restore your data.\nPlease note: Restoring will overwrite your current data.';
			case 'backup.successMessage': return 'Backup created successfully!';
			case 'backup.failedMessage': return 'Failed to create backup';
			case 'backup.restoreFailedMessage': return 'Failed to restore backup';
			case 'backup.restoreSuccess': return 'Restoring your backup was successful';
			case 'backup.actions.create': return 'Create Backup';
			case 'backup.actions.restore': return 'Restore Backup';
			case 'backup.actions.goToHome': return 'Go to Home';
			default: return null;
		}
	}
}

