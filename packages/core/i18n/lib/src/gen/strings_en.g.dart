///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'One Page'
	String get title => 'One Page';

	/// en: 'NPK Studio'
	String get organization => 'NPK Studio';

	late final Translations$updateRequest$en updateRequest = Translations$updateRequest$en._(_root);
	late final Translations$home$en home = Translations$home$en._(_root);
	late final Translations$photoRecovery$en photoRecovery = Translations$photoRecovery$en._(_root);
	late final Translations$backup$en backup = Translations$backup$en._(_root);
	late final Translations$settings$en settings = Translations$settings$en._(_root);
	late final Translations$search$en search = Translations$search$en._(_root);
	late final Translations$notification$en notification = Translations$notification$en._(_root);
	late final Translations$export$en export = Translations$export$en._(_root);
}

// Path: updateRequest
class Translations$updateRequest$en {
	Translations$updateRequest$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update Request'
	String get title => 'Update Request';

	late final Translations$updateRequest$button$en button = Translations$updateRequest$button$en._(_root);
}

// Path: home
class Translations$home$en {
	Translations$home$en._(this._root);

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

	late final Translations$home$photoSelector$en photoSelector = Translations$home$photoSelector$en._(_root);
	late final Translations$home$deleteImage$en deleteImage = Translations$home$deleteImage$en._(_root);
}

// Path: photoRecovery
class Translations$photoRecovery$en {
	Translations$photoRecovery$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recover Photos'
	String get title => 'Recover Photos';

	/// en: 'Some photos need to be recovered'
	String get banner => 'Some photos need to be recovered';

	/// en: '(one) {$count photo is not shown yet} (other) {$count photos are not shown yet}'
	String notShown({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} photo is not shown yet',
		other: '${count} photos are not shown yet',
	);

	/// en: '(one) {$count photo cannot be found on this device} (other) {$count photos cannot be found on this device}'
	String notFound({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} photo cannot be found on this device',
		other: '${count} photos cannot be found on this device',
	);

	/// en: 'Photos are now saved in the app'
	String get savedInApp => 'Photos are now saved in the app';

	/// en: 'Your earlier photos will show again once recovered'
	String get shownAfterRecovery => 'Your earlier photos will show again once recovered';

	/// en: 'Photos deleted from this device cannot be recovered'
	String get deletedFromDevice => 'Photos deleted from this device cannot be recovered';

	/// en: 'Recover'
	String get action => 'Recover';

	/// en: 'Recovering photos'
	String get progress => 'Recovering photos';

	late final Translations$photoRecovery$done$en done = Translations$photoRecovery$done$en._(_root);

	/// en: '$completed / $total'
	String progressCount({required Object completed, required Object total}) => '${completed} / ${total}';

	late final Translations$photoRecovery$folder$en folder = Translations$photoRecovery$folder$en._(_root);
	late final Translations$photoRecovery$settings$en settings = Translations$photoRecovery$settings$en._(_root);

	/// en: 'Recover'
	String get remind => 'Recover';

	/// en: 'Delete This Photo'
	String get deletePhoto => 'Delete This Photo';

	late final Translations$photoRecovery$deleteConfirm$en deleteConfirm = Translations$photoRecovery$deleteConfirm$en._(_root);
	late final Translations$photoRecovery$deleteUnrecovered$en deleteUnrecovered = Translations$photoRecovery$deleteUnrecovered$en._(_root);
	late final Translations$photoRecovery$dismiss$en dismiss = Translations$photoRecovery$dismiss$en._(_root);

	/// en: 'Photos recovered: $count'
	String recovered({required Object count}) => 'Photos recovered: ${count}';

	/// en: 'Could not recover photos'
	String get failed => 'Could not recover photos';
}

// Path: backup
class Translations$backup$en {
	Translations$backup$en._(this._root);

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

	late final Translations$backup$progress$en progress = Translations$backup$progress$en._(_root);
	late final Translations$backup$legacyRestore$en legacyRestore = Translations$backup$legacyRestore$en._(_root);
	late final Translations$backup$actions$en actions = Translations$backup$actions$en._(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

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
class Translations$search$en {
	Translations$search$en._(this._root);

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
class Translations$notification$en {
	Translations$notification$en._(this._root);

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

	late final Translations$notification$permission$en permission = Translations$notification$permission$en._(_root);

	/// en: 'Have you written your diary today?'
	String get notificationTitle => 'Have you written your diary today?';

	/// en: 'Take a moment to jot down your thoughts and feelings'
	String get notificationBody => 'Take a moment to jot down your thoughts and feelings';
}

// Path: export
class Translations$export$en {
	Translations$export$en._(this._root);

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

	late final Translations$export$actions$en actions = Translations$export$actions$en._(_root);
}

// Path: updateRequest.button
class Translations$updateRequest$button$en {
	Translations$updateRequest$button$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update Now'
	String get updateNow => 'Update Now';
}

// Path: home.photoSelector
class Translations$home$photoSelector$en {
	Translations$home$photoSelector$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$home$photoSelector$notice$en notice = Translations$home$photoSelector$notice$en._(_root);
	late final Translations$home$photoSelector$error$en error = Translations$home$photoSelector$error$en._(_root);
}

// Path: home.deleteImage
class Translations$home$deleteImage$en {
	Translations$home$deleteImage$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete Image'
	String get title => 'Delete Image';

	/// en: 'Are you sure you want to delete this image?'
	String get message => 'Are you sure you want to delete this image?';
}

// Path: photoRecovery.done
class Translations$photoRecovery$done$en {
	Translations$photoRecovery$done$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All photos have been recovered'
	String get title => 'All photos have been recovered';

	/// en: 'Your earlier photos now show in your diary'
	String get message => 'Your earlier photos now show in your diary';

	/// en: 'Back to Diary'
	String get action => 'Back to Diary';
}

// Path: photoRecovery.folder
class Translations$photoRecovery$folder$en {
	Translations$photoRecovery$folder$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select a folder with your photos, such as DCIM or Pictures'
	String get message => 'Select a folder with your photos, such as DCIM or Pictures';

	/// en: 'Select Folder and Recover'
	String get action => 'Select Folder and Recover';
}

// Path: photoRecovery.settings
class Translations$photoRecovery$settings$en {
	Translations$photoRecovery$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Allow photo access in Settings'
	String get title => 'Allow photo access in Settings';

	/// en: 'After you allow access, you can recover your earlier photos'
	String get message => 'After you allow access, you can recover your earlier photos';

	/// en: 'Open Settings'
	String get action => 'Open Settings';
}

// Path: photoRecovery.deleteConfirm
class Translations$photoRecovery$deleteConfirm$en {
	Translations$photoRecovery$deleteConfirm$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete Photo'
	String get title => 'Delete Photo';

	/// en: 'Delete this photo from your diary?'
	String get message => 'Delete this photo from your diary?';
}

// Path: photoRecovery.deleteUnrecovered
class Translations$photoRecovery$deleteUnrecovered$en {
	Translations$photoRecovery$deleteUnrecovered$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete Photos That Are Not Shown'
	String get action => 'Delete Photos That Are Not Shown';

	/// en: 'Delete photos that are not shown?'
	String get title => 'Delete photos that are not shown?';

	/// en: '(one) {Photos you deleted from your library, or did not move to a new device, cannot be shown. $count photo that is not shown will be deleted from your diaries.} (other) {Photos you deleted from your library, or did not move to a new device, cannot be shown. $count photos that are not shown will be deleted from your diaries.}'
	String message({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: 'Photos you deleted from your library, or did not move to a new device, cannot be shown. ${count} photo that is not shown will be deleted from your diaries.',
		other: 'Photos you deleted from your library, or did not move to a new device, cannot be shown. ${count} photos that are not shown will be deleted from your diaries.',
	);
}

// Path: photoRecovery.dismiss
class Translations$photoRecovery$dismiss$en {
	Translations$photoRecovery$dismiss$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Do Not Recover the Remaining Photos'
	String get action => 'Do Not Recover the Remaining Photos';

	/// en: 'Stop recovering photos?'
	String get title => 'Stop recovering photos?';

	/// en: 'You will no longer see reminders to recover photos. You can still recover photos from the menu.'
	String get message => 'You will no longer see reminders to recover photos. You can still recover photos from the menu.';
}

// Path: backup.progress
class Translations$backup$progress$en {
	Translations$backup$progress$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Creating backup'
	String get creating => 'Creating backup';

	/// en: 'Restoring backup'
	String get restoring => 'Restoring backup';
}

// Path: backup.legacyRestore
class Translations$backup$legacyRestore$en {
	Translations$backup$legacyRestore$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Photos are not included'
	String get title => 'Photos are not included';

	/// en: 'This backup uses an older format. Restoring replaces your current diary and photos with its contents.'
	String get message => 'This backup uses an older format.\nRestoring replaces your current diary and photos with its contents.';

	/// en: 'Restore'
	String get confirm => 'Restore';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
}

// Path: backup.actions
class Translations$backup$actions$en {
	Translations$backup$actions$en._(this._root);

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
class Translations$notification$permission$en {
	Translations$notification$permission$en._(this._root);

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
class Translations$export$actions$en {
	Translations$export$actions$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Export by Month'
	String get exportMonth => 'Export by Month';

	/// en: 'Export'
	String get export => 'Export';
}

// Path: home.photoSelector.notice
class Translations$home$photoSelector$notice$en {
	Translations$home$photoSelector$notice$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Important Notes about Photos'
	String get title => 'Important Notes about Photos';

	/// en: '• One photo per date • May not transfer when switching devices • Cloud backup planned for the future'
	String get message => '• One photo per date\n• May not transfer when switching devices\n• Cloud backup planned for the future';

	/// en: 'OK'
	String get confirm => 'OK';
}

// Path: home.photoSelector.error
class Translations$home$photoSelector$error$en {
	Translations$home$photoSelector$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'An error occurred while saving the image'
	String get title => 'An error occurred while saving the image';

	/// en: 'Please try again'
	String get description => 'Please try again';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
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
			'home.photoSelector.notice.title' => 'Important Notes about Photos',
			'home.photoSelector.notice.message' => '• One photo per date\n• May not transfer when switching devices\n• Cloud backup planned for the future',
			'home.photoSelector.notice.confirm' => 'OK',
			'home.photoSelector.error.title' => 'An error occurred while saving the image',
			'home.photoSelector.error.description' => 'Please try again',
			'home.deleteImage.title' => 'Delete Image',
			'home.deleteImage.message' => 'Are you sure you want to delete this image?',
			'photoRecovery.title' => 'Recover Photos',
			'photoRecovery.banner' => 'Some photos need to be recovered',
			'photoRecovery.notShown' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} photo is not shown yet', other: '${count} photos are not shown yet', ), 
			'photoRecovery.notFound' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} photo cannot be found on this device', other: '${count} photos cannot be found on this device', ), 
			'photoRecovery.savedInApp' => 'Photos are now saved in the app',
			'photoRecovery.shownAfterRecovery' => 'Your earlier photos will show again once recovered',
			'photoRecovery.deletedFromDevice' => 'Photos deleted from this device cannot be recovered',
			'photoRecovery.action' => 'Recover',
			'photoRecovery.progress' => 'Recovering photos',
			'photoRecovery.done.title' => 'All photos have been recovered',
			'photoRecovery.done.message' => 'Your earlier photos now show in your diary',
			'photoRecovery.done.action' => 'Back to Diary',
			'photoRecovery.progressCount' => ({required Object completed, required Object total}) => '${completed} / ${total}',
			'photoRecovery.folder.message' => 'Select a folder with your photos, such as DCIM or Pictures',
			'photoRecovery.folder.action' => 'Select Folder and Recover',
			'photoRecovery.settings.title' => 'Allow photo access in Settings',
			'photoRecovery.settings.message' => 'After you allow access, you can recover your earlier photos',
			'photoRecovery.settings.action' => 'Open Settings',
			'photoRecovery.remind' => 'Recover',
			'photoRecovery.deletePhoto' => 'Delete This Photo',
			'photoRecovery.deleteConfirm.title' => 'Delete Photo',
			'photoRecovery.deleteConfirm.message' => 'Delete this photo from your diary?',
			'photoRecovery.deleteUnrecovered.action' => 'Delete Photos That Are Not Shown',
			'photoRecovery.deleteUnrecovered.title' => 'Delete photos that are not shown?',
			'photoRecovery.deleteUnrecovered.message' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: 'Photos you deleted from your library, or did not move to a new device, cannot be shown. ${count} photo that is not shown will be deleted from your diaries.', other: 'Photos you deleted from your library, or did not move to a new device, cannot be shown. ${count} photos that are not shown will be deleted from your diaries.', ), 
			'photoRecovery.dismiss.action' => 'Do Not Recover the Remaining Photos',
			'photoRecovery.dismiss.title' => 'Stop recovering photos?',
			'photoRecovery.dismiss.message' => 'You will no longer see reminders to recover photos. You can still recover photos from the menu.',
			'photoRecovery.recovered' => ({required Object count}) => 'Photos recovered: ${count}',
			'photoRecovery.failed' => 'Could not recover photos',
			'backup.title' => 'Backup',
			'backup.description' => 'Backup for a Smooth Device Switch',
			'backup.explanation' => 'Easily generate a backup file and save it wherever you prefer (e.g., iCloud, Google Drive, etc.).',
			'backup.restoreExplanation' => 'Simply select the saved backup file to restore your data.\nPlease note: Restoring will overwrite your current data.',
			'backup.successMessage' => 'Backup created successfully!',
			'backup.failedMessage' => 'Failed to create backup',
			'backup.restoreFailedMessage' => 'Failed to restore backup',
			'backup.restoreSuccess' => 'Restoring your backup was successful',
			'backup.progress.creating' => 'Creating backup',
			'backup.progress.restoring' => 'Restoring backup',
			'backup.legacyRestore.title' => 'Photos are not included',
			'backup.legacyRestore.message' => 'This backup uses an older format.\nRestoring replaces your current diary and photos with its contents.',
			'backup.legacyRestore.confirm' => 'Restore',
			'backup.legacyRestore.cancel' => 'Cancel',
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
