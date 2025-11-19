///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

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

	/// en: 'One Page'
	String get title => 'One Page';

	/// en: 'NPK Studio'
	String get organization => 'NPK Studio';

	late final TranslationsUpdateRequestEn updateRequest = TranslationsUpdateRequestEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsBackupEn backup = TranslationsBackupEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsSearchEn search = TranslationsSearchEn._(_root);
	late final TranslationsNotificationEn notification = TranslationsNotificationEn._(_root);
	late final TranslationsExportEn export = TranslationsExportEn._(_root);
}

// Path: updateRequest
class TranslationsUpdateRequestEn {
	TranslationsUpdateRequestEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update Request'
	String get title => 'Update Request';

	late final TranslationsUpdateRequestButtonEn button = TranslationsUpdateRequestButtonEn._(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get title => 'Home';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Backup'
	String get backup => 'Backup';

	/// en: 'Export'
	String get export => 'Export';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'License'
	String get license => 'License';

	/// en: 'An error occurred while saving your diary'
	String get errorSavingDiary => 'An error occurred while saving your diary';

	/// en: 'We apologize, but please copy your text and restart the app'
	String get errorSavingDiarySolution => 'We apologize, but please copy your text and restart the app';

	/// en: 'Cancel'
	String get datePickerCancel => 'Cancel';

	/// en: 'OK'
	String get datePickerConfirm => 'OK';
}

// Path: backup
class TranslationsBackupEn {
	TranslationsBackupEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Backup'
	String get title => 'Backup';

	/// en: 'Backup for a Smooth Device Switch'
	String get description => 'Backup for a Smooth Device Switch';

	/// en: 'Easily generate a backup file and save it wherever you prefer (e.g., iCloud, Google Drive, etc.).'
	String get explanation => 'Easily generate a backup file and save it wherever you prefer (e.g., iCloud, Google Drive, etc.).';

	/// en: 'Simply select the saved backup file to restore your data. Please note: Restoring will overwrite your current data.'
	String get restoreExplanation => 'Simply select the saved backup file to restore your data.\nPlease note: Restoring will overwrite your current data.';

	/// en: 'Backup created successfully!'
	String get successMessage => 'Backup created successfully!';

	/// en: 'Failed to create backup'
	String get failedMessage => 'Failed to create backup';

	/// en: 'Failed to restore backup'
	String get restoreFailedMessage => 'Failed to restore backup';

	/// en: 'Restoring your backup was successful'
	String get restoreSuccess => 'Restoring your backup was successful';

	late final TranslationsBackupActionsEn actions = TranslationsBackupActionsEn._(_root);
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Accessibility'
	String get accessibility => 'Accessibility';

	/// en: 'Haptic Feedback'
	String get hapticFeedback => 'Haptic Feedback';

	/// en: 'Vibration Settings'
	String get vibrationSettings => 'Vibration Settings';

	/// en: 'Text Input'
	String get textInput => 'Text Input';

	/// en: 'Vibration settings during text input'
	String get textInputDescription => 'Vibration settings during text input';

	/// en: 'Other'
	String get other => 'Other';

	/// en: 'Vibration settings for icon taps and other actions'
	String get otherDescription => 'Vibration settings for icon taps and other actions';
}

// Path: search
class TranslationsSearchEn {
	TranslationsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter search keyword'
	String get searchHint => 'Enter search keyword';

	/// en: 'Search results will appear here'
	String get placeholder => 'Search results will appear here';

	/// en: 'No search results found'
	String get noResults => 'No search results found';
}

// Path: notification
class TranslationsNotificationEn {
	TranslationsNotificationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get title => 'Notifications';

	/// en: 'Add time'
	String get addTime => 'Add time';

	/// en: 'Maximum 3 notification times allowed'
	String get maxTimesReached => 'Maximum 3 notification times allowed';

	/// en: 'Diary Reminder'
	String get channelName => 'Diary Reminder';

	/// en: 'Daily reminders to write in your diary'
	String get channelDescription => 'Daily reminders to write in your diary';

	late final TranslationsNotificationPermissionEn permission = TranslationsNotificationPermissionEn._(_root);

	/// en: 'Have you written your diary today?'
	String get notificationTitle => 'Have you written your diary today?';

	/// en: 'Take a moment to jot down your thoughts and feelings'
	String get notificationBody => 'Take a moment to jot down your thoughts and feelings';
}

// Path: export
class TranslationsExportEn {
	TranslationsExportEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Export'
	String get title => 'Export';

	/// en: 'Export diary to PDF'
	String get description => 'Export diary to PDF';

	/// en: 'Export your diary entries as PDF files organized by month'
	String get explanation => 'Export your diary entries as PDF files\norganized by month';

	/// en: 'Export completed successfully!'
	String get successMessage => 'Export completed successfully!';

	/// en: 'Export failed'
	String get failedMessage => 'Export failed';

	/// en: 'MMMM yyyy'
	String get monthFormat => 'MMMM yyyy';

	/// en: 'Export Format'
	String get formatSelection => 'Export Format';

	/// en: 'Select Month'
	String get monthSelection => 'Select Month';

	/// en: 'Year'
	String get year => 'Year';

	/// en: 'Month'
	String get month => 'Month';

	/// en: 'Coming in future updates'
	String get comingSoon => 'Coming in future updates';

	late final TranslationsExportActionsEn actions = TranslationsExportActionsEn._(_root);
}

// Path: updateRequest.button
class TranslationsUpdateRequestButtonEn {
	TranslationsUpdateRequestButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update Now'
	String get updateNow => 'Update Now';
}

// Path: backup.actions
class TranslationsBackupActionsEn {
	TranslationsBackupActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create Backup'
	String get create => 'Create Backup';

	/// en: 'Restore Backup'
	String get restore => 'Restore Backup';

	/// en: 'Go to Home'
	String get goToHome => 'Go to Home';
}

// Path: notification.permission
class TranslationsNotificationPermissionEn {
	TranslationsNotificationPermissionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notification Permission Required'
	String get deniedTitle => 'Notification Permission Required';

	/// en: 'Please enable notifications in your device settings to receive reminders'
	String get deniedMessage => 'Please enable notifications in your device settings to receive reminders';

	/// en: 'Open Settings'
	String get openSettings => 'Open Settings';
}

// Path: export.actions
class TranslationsExportActionsEn {
	TranslationsExportActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Export by Month'
	String get exportMonth => 'Export by Month';

	/// en: 'Export'
	String get export => 'Export';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return _flatMapFunction$0(path);
	}

	dynamic _flatMapFunction$0(String path) {
		return switch (path) {
			'title' => 'One Page',
			'organization' => 'NPK Studio',
			'updateRequest.title' => 'Update Request',
			'updateRequest.button.updateNow' => 'Update Now',
			'home.title' => 'Home',
			'home.notifications' => 'Notifications',
			'home.backup' => 'Backup',
			'home.export' => 'Export',
			'home.settings' => 'Settings',
			'home.license' => 'License',
			'home.errorSavingDiary' => 'An error occurred while saving your diary',
			'home.errorSavingDiarySolution' => 'We apologize, but please copy your text and restart the app',
			'home.datePickerCancel' => 'Cancel',
			'home.datePickerConfirm' => 'OK',
			'backup.title' => 'Backup',
			'backup.description' => 'Backup for a Smooth Device Switch',
			'backup.explanation' => 'Easily generate a backup file and save it wherever you prefer (e.g., iCloud, Google Drive, etc.).',
			'backup.restoreExplanation' => 'Simply select the saved backup file to restore your data.\nPlease note: Restoring will overwrite your current data.',
			'backup.successMessage' => 'Backup created successfully!',
			'backup.failedMessage' => 'Failed to create backup',
			'backup.restoreFailedMessage' => 'Failed to restore backup',
			'backup.restoreSuccess' => 'Restoring your backup was successful',
			'backup.actions.create' => 'Create Backup',
			'backup.actions.restore' => 'Restore Backup',
			'backup.actions.goToHome' => 'Go to Home',
			'settings.title' => 'Settings',
			'settings.accessibility' => 'Accessibility',
			'settings.hapticFeedback' => 'Haptic Feedback',
			'settings.vibrationSettings' => 'Vibration Settings',
			'settings.textInput' => 'Text Input',
			'settings.textInputDescription' => 'Vibration settings during text input',
			'settings.other' => 'Other',
			'settings.otherDescription' => 'Vibration settings for icon taps and other actions',
			'search.searchHint' => 'Enter search keyword',
			'search.placeholder' => 'Search results will appear here',
			'search.noResults' => 'No search results found',
			'notification.title' => 'Notifications',
			'notification.addTime' => 'Add time',
			'notification.maxTimesReached' => 'Maximum 3 notification times allowed',
			'notification.channelName' => 'Diary Reminder',
			'notification.channelDescription' => 'Daily reminders to write in your diary',
			'notification.permission.deniedTitle' => 'Notification Permission Required',
			'notification.permission.deniedMessage' => 'Please enable notifications in your device settings to receive reminders',
			'notification.permission.openSettings' => 'Open Settings',
			'notification.notificationTitle' => 'Have you written your diary today?',
			'notification.notificationBody' => 'Take a moment to jot down your thoughts and feelings',
			'export.title' => 'Export',
			'export.description' => 'Export diary to PDF',
			'export.explanation' => 'Export your diary entries as PDF files\norganized by month',
			'export.successMessage' => 'Export completed successfully!',
			'export.failedMessage' => 'Export failed',
			'export.monthFormat' => 'MMMM yyyy',
			'export.formatSelection' => 'Export Format',
			'export.monthSelection' => 'Select Month',
			'export.year' => 'Year',
			'export.month' => 'Month',
			'export.comingSoon' => 'Coming in future updates',
			'export.actions.exportMonth' => 'Export by Month',
			'export.actions.export' => 'Export',
			_ => null,
		};
	}
}

