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
	late final TranslationsSearchEn search = TranslationsSearchEn._(_root);
	late final TranslationsNotificationEn notification = TranslationsNotificationEn._(_root);
	late final TranslationsExportEn export = TranslationsExportEn._(_root);
	late final TranslationsInAppReviewEn inAppReview = TranslationsInAppReviewEn._(_root);
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
	String get notifications => 'Notifications';
	String get backup => 'Backup';
	String get export => 'Export';
	String get settings => 'Settings';
	String get license => 'License';
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

// Path: search
class TranslationsSearchEn {
	TranslationsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get searchHint => 'Enter search keyword';
	String get placeholder => 'Search results will appear here';
	String get noResults => 'No search results found';
}

// Path: notification
class TranslationsNotificationEn {
	TranslationsNotificationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Notifications';
	String get addTime => 'Add time';
	String get maxTimesReached => 'Maximum 3 notification times allowed';
	String get channelName => 'Diary Reminder';
	String get channelDescription => 'Daily reminders to write in your diary';
	late final TranslationsNotificationPermissionEn permission = TranslationsNotificationPermissionEn._(_root);
	String get notificationTitle => 'Have you written your diary today?';
	String get notificationBody => 'Take a moment to jot down your thoughts and feelings';
}

// Path: export
class TranslationsExportEn {
	TranslationsExportEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Export';
	String get description => 'Export diary to PDF';
	String get explanation => 'Export your diary entries as PDF files\norganized by month';
	String get successMessage => 'Export completed successfully!';
	String get failedMessage => 'Export failed';
	String get monthFormat => 'MMMM yyyy';
	String get formatSelection => 'Export Format';
	String get monthSelection => 'Select Month';
	String get year => 'Year';
	String get month => 'Month';
	String get comingSoon => 'Coming in future updates';
	late final TranslationsExportActionsEn actions = TranslationsExportActionsEn._(_root);
}

// Path: inAppReview
class TranslationsInAppReviewEn {
	TranslationsInAppReviewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Rate Our App';
	String get message => 'Are you enjoying One Page?\nWe\'d love if you could rate us on the Store.';
	late final TranslationsInAppReviewActionsEn actions = TranslationsInAppReviewActionsEn._(_root);
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

// Path: notification.permission
class TranslationsNotificationPermissionEn {
	TranslationsNotificationPermissionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get deniedTitle => 'Notification Permission Required';
	String get deniedMessage => 'Please enable notifications in your device settings to receive reminders';
	String get openSettings => 'Open Settings';
}

// Path: export.actions
class TranslationsExportActionsEn {
	TranslationsExportActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get exportMonth => 'Export by Month';
	String get export => 'Export';
}

// Path: inAppReview.actions
class TranslationsInAppReviewActionsEn {
	TranslationsInAppReviewActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get review => 'Rate Now';
	String get notNow => 'Not Now';
	String get never => 'Don\'t Ask Again';
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
			case 'home.notifications': return 'Notifications';
			case 'home.backup': return 'Backup';
			case 'home.export': return 'Export';
			case 'home.settings': return 'Settings';
			case 'home.license': return 'License';
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
			case 'search.searchHint': return 'Enter search keyword';
			case 'search.placeholder': return 'Search results will appear here';
			case 'search.noResults': return 'No search results found';
			case 'notification.title': return 'Notifications';
			case 'notification.addTime': return 'Add time';
			case 'notification.maxTimesReached': return 'Maximum 3 notification times allowed';
			case 'notification.channelName': return 'Diary Reminder';
			case 'notification.channelDescription': return 'Daily reminders to write in your diary';
			case 'notification.permission.deniedTitle': return 'Notification Permission Required';
			case 'notification.permission.deniedMessage': return 'Please enable notifications in your device settings to receive reminders';
			case 'notification.permission.openSettings': return 'Open Settings';
			case 'notification.notificationTitle': return 'Have you written your diary today?';
			case 'notification.notificationBody': return 'Take a moment to jot down your thoughts and feelings';
			case 'export.title': return 'Export';
			case 'export.description': return 'Export diary to PDF';
			case 'export.explanation': return 'Export your diary entries as PDF files\norganized by month';
			case 'export.successMessage': return 'Export completed successfully!';
			case 'export.failedMessage': return 'Export failed';
			case 'export.monthFormat': return 'MMMM yyyy';
			case 'export.formatSelection': return 'Export Format';
			case 'export.monthSelection': return 'Select Month';
			case 'export.year': return 'Year';
			case 'export.month': return 'Month';
			case 'export.comingSoon': return 'Coming in future updates';
			case 'export.actions.exportMonth': return 'Export by Month';
			case 'export.actions.export': return 'Export';
			case 'inAppReview.title': return 'Rate Our App';
			case 'inAppReview.message': return 'Are you enjoying One Page?\nWe\'d love if you could rate us on the Store.';
			case 'inAppReview.actions.review': return 'Rate Now';
			case 'inAppReview.actions.notNow': return 'Not Now';
			case 'inAppReview.actions.never': return 'Don\'t Ask Again';
			default: return null;
		}
	}
}

