///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	String get title => 'One Page';
	String get organization => 'NPK Studio';
	late final TranslationsUpdateRequestEn updateRequest = TranslationsUpdateRequestEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsBackupEn backup = TranslationsBackupEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
}

// Path: updateRequest
class TranslationsUpdateRequestEn {
	TranslationsUpdateRequestEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Update Request';
	late final TranslationsUpdateRequestButtonEn button = TranslationsUpdateRequestButtonEn._(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	String get license => 'License';
	String get backup => 'Backup';
	String get errorSavingDiary => 'An error occurred while saving your diary';
	String get errorSavingDiarySolution => 'We apologize, but please copy your text and restart the app';
	String get datePickerCancel => 'Cancel';
	String get datePickerConfirm => 'OK';
}

// Path: backup
class TranslationsBackupEn {
	TranslationsBackupEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Backup';
	String get description => 'Backup for a Smooth Device Switch';
	String get explanation => 'Easily generate a backup file and save it wherever you prefer (e.g., iCloud, Google Drive, etc.).';
	String get restoreExplanation => 'Simply select the saved backup file to restore your data.\nPlease note: Restoring will overwrite your current data.';
	String get successMessage => 'Backup created successfully!';
	String get failedMessage => 'Failed to create backup';
	String get restoreFailedMessage => 'Failed to restore backup';
	String get restoreSuccess => 'Restoring your backup was successful';
	late final TranslationsBackupActionsEn actions = TranslationsBackupActionsEn._(_root);
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get accessibility => 'Accessibility';
	String get hapticFeedback => 'Haptic Feedback';
	String get vibrationSettings => 'Vibration Settings';
	String get textInput => 'Text Input';
	String get textInputDescription => 'Vibration settings during text input';
	String get other => 'Other';
	String get otherDescription => 'Vibration settings for icon taps and other actions';
}

// Path: updateRequest.button
class TranslationsUpdateRequestButtonEn {
	TranslationsUpdateRequestButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get updateNow => 'Update Now';
}

// Path: backup.actions
class TranslationsBackupActionsEn {
	TranslationsBackupActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get create => 'Create Backup';
	String get restore => 'Restore Backup';
	String get goToHome => 'Go to Home';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
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
			case 'home.datePickerCancel': return 'Cancel';
			case 'home.datePickerConfirm': return 'OK';
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
			case 'settings.title': return 'Settings';
			case 'settings.accessibility': return 'Accessibility';
			case 'settings.hapticFeedback': return 'Haptic Feedback';
			case 'settings.vibrationSettings': return 'Vibration Settings';
			case 'settings.textInput': return 'Text Input';
			case 'settings.textInputDescription': return 'Vibration settings during text input';
			case 'settings.other': return 'Other';
			case 'settings.otherDescription': return 'Vibration settings for icon taps and other actions';
			default: return null;
		}
	}
}

