///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsJa with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override String get title => 'One Page';
	@override String get organization => 'NPK Studio';
	@override late final _TranslationsUpdateRequestJa updateRequest = _TranslationsUpdateRequestJa._(_root);
	@override late final _TranslationsHomeJa home = _TranslationsHomeJa._(_root);
	@override late final _TranslationsBackupJa backup = _TranslationsBackupJa._(_root);
	@override late final _TranslationsSettingsJa settings = _TranslationsSettingsJa._(_root);
	@override late final _TranslationsSearchJa search = _TranslationsSearchJa._(_root);
	@override late final _TranslationsNotificationJa notification = _TranslationsNotificationJa._(_root);
	@override late final _TranslationsExportJa export = _TranslationsExportJa._(_root);
}

// Path: updateRequest
class _TranslationsUpdateRequestJa implements TranslationsUpdateRequestEn {
	_TranslationsUpdateRequestJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アップデートのお願い';
	@override late final _TranslationsUpdateRequestButtonJa button = _TranslationsUpdateRequestButtonJa._(_root);
}

// Path: home
class _TranslationsHomeJa implements TranslationsHomeEn {
	_TranslationsHomeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Home';
	@override String get notifications => 'Notifications';
	@override String get backup => 'Backup';
	@override String get export => 'Export';
	@override String get settings => 'Settings';
	@override String get license => 'License';
	@override String get errorSavingDiary => '日記の保存中にエラーが発生しました';
	@override String get errorSavingDiarySolution => '申し訳ありませんが、入力中のテキストをコピーしてからアプリを再起動してください';
	@override String get datePickerCancel => 'キャンセル';
	@override String get datePickerConfirm => '決定';
	@override late final _TranslationsHomePhotoSelectorJa photoSelector = _TranslationsHomePhotoSelectorJa._(_root);
	@override late final _TranslationsHomeDeleteImageJa deleteImage = _TranslationsHomeDeleteImageJa._(_root);
}

// Path: backup
class _TranslationsBackupJa implements TranslationsBackupEn {
	_TranslationsBackupJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Backup';
	@override String get description => '機種変更でも安心バックアップ';
	@override String get explanation => 'バックアップファイルが作成できます\n好きなところに保存してください\n（iCloud、Google Drive など）';
	@override String get restoreExplanation => '保存したバックアップファイルを\n選択して復元できます\n復元時は現在のデータが\n上書きされるため注意してください';
	@override String get successMessage => 'バックアップが正常に作成されました！';
	@override String get failedMessage => 'バックアップの作成に失敗しました';
	@override String get restoreFailedMessage => 'バックアップの復元に失敗しました';
	@override String get restoreSuccess => '復元が完了しました';
	@override late final _TranslationsBackupActionsJa actions = _TranslationsBackupActionsJa._(_root);
}

// Path: settings
class _TranslationsSettingsJa implements TranslationsSettingsEn {
	_TranslationsSettingsJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Settings';
	@override String get accessibility => 'アクセシビリティ';
	@override String get hapticFeedback => '触覚フィードバック';
	@override String get vibrationSettings => '振動設定';
	@override String get textInput => '文字入力';
	@override String get textInputDescription => '文字入力中の振動設定';
	@override String get other => 'その他';
	@override String get otherDescription => 'アイコンタップなどの振動設定';
}

// Path: search
class _TranslationsSearchJa implements TranslationsSearchEn {
	_TranslationsSearchJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get searchHint => '検索キーワードを入力';
	@override String get placeholder => '検索結果がここに表示されます';
	@override String get noResults => '検索結果がありません';
}

// Path: notification
class _TranslationsNotificationJa implements TranslationsNotificationEn {
	_TranslationsNotificationJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifications';
	@override String get addTime => '時間を追加';
	@override String get maxTimesReached => '通知時間は最大3つまでです';
	@override String get channelName => '日記リマインダー';
	@override String get channelDescription => '日記を書くための日々のリマインダー';
	@override late final _TranslationsNotificationPermissionJa permission = _TranslationsNotificationPermissionJa._(_root);
	@override String get notificationTitle => '今日の日記は書きましたか？';
	@override String get notificationBody => '1日の出来事や気持ちを書き留めておきましょう';
}

// Path: export
class _TranslationsExportJa implements TranslationsExportEn {
	_TranslationsExportJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Export';
	@override String get description => '日記をPDFで出力';
	@override String get explanation => '月ごとに日記をPDFファイルで\nエクスポートできます';
	@override String get successMessage => 'エクスポートが完了しました！';
	@override String get failedMessage => 'エクスポートに失敗しました';
	@override String get monthFormat => 'yyyy年MM月';
	@override String get formatSelection => 'エクスポート形式';
	@override String get monthSelection => '月を選択';
	@override String get year => '年';
	@override String get month => '月';
	@override String get comingSoon => '今後追加予定です';
	@override late final _TranslationsExportActionsJa actions = _TranslationsExportActionsJa._(_root);
}

// Path: updateRequest.button
class _TranslationsUpdateRequestButtonJa implements TranslationsUpdateRequestButtonEn {
	_TranslationsUpdateRequestButtonJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get updateNow => '更新する';
}

// Path: home.photoSelector
class _TranslationsHomePhotoSelectorJa implements TranslationsHomePhotoSelectorEn {
	_TranslationsHomePhotoSelectorJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get confirm => '決定';
	@override String get noPhotos => '写真がありません';
	@override late final _TranslationsHomePhotoSelectorPermissionJa permission = _TranslationsHomePhotoSelectorPermissionJa._(_root);
	@override late final _TranslationsHomePhotoSelectorNoticeJa notice = _TranslationsHomePhotoSelectorNoticeJa._(_root);
	@override late final _TranslationsHomePhotoSelectorErrorJa error = _TranslationsHomePhotoSelectorErrorJa._(_root);
}

// Path: home.deleteImage
class _TranslationsHomeDeleteImageJa implements TranslationsHomeDeleteImageEn {
	_TranslationsHomeDeleteImageJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '画像を削除';
	@override String get message => 'この画像を削除しますか？';
}

// Path: backup.actions
class _TranslationsBackupActionsJa implements TranslationsBackupActionsEn {
	_TranslationsBackupActionsJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get create => 'バックアップを作成';
	@override String get restore => 'バックアップを復元';
	@override String get goToHome => 'ホームへ戻る';
}

// Path: notification.permission
class _TranslationsNotificationPermissionJa implements TranslationsNotificationPermissionEn {
	_TranslationsNotificationPermissionJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get deniedTitle => '通知権限が必要です';
	@override String get deniedMessage => 'アプリの通知を有効にするには、端末の設定で通知を許可してください';
	@override String get openSettings => '設定を開く';
}

// Path: export.actions
class _TranslationsExportActionsJa implements TranslationsExportActionsEn {
	_TranslationsExportActionsJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get exportMonth => '月別エクスポート';
	@override String get export => 'エクスポート';
}

// Path: home.photoSelector.permission
class _TranslationsHomePhotoSelectorPermissionJa implements TranslationsHomePhotoSelectorPermissionEn {
	_TranslationsHomePhotoSelectorPermissionJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get deniedTitle => '写真ライブラリへのアクセス権限が必要です';
	@override String get deniedMessage => '設定からアプリに写真ライブラリへのアクセスを許可してください';
	@override String get openSettings => '設定を開く';
}

// Path: home.photoSelector.notice
class _TranslationsHomePhotoSelectorNoticeJa implements TranslationsHomePhotoSelectorNoticeEn {
	_TranslationsHomePhotoSelectorNoticeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '写真の注意点';
	@override String get message => '• 日付ごとに1枚まで添付できます\n• 端末から削除すると表示されません\n• 機種変更で失われる可能性があります\n• クラウド保存は対応予定です';
	@override String get confirm => 'OK';
}

// Path: home.photoSelector.error
class _TranslationsHomePhotoSelectorErrorJa implements TranslationsHomePhotoSelectorErrorEn {
	_TranslationsHomePhotoSelectorErrorJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '画像の保存中にエラーが発生しました';
	@override String get description => 'もう一度お試しください';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'title' => 'One Page',
			'organization' => 'NPK Studio',
			'updateRequest.title' => 'アップデートのお願い',
			'updateRequest.button.updateNow' => '更新する',
			'home.title' => 'Home',
			'home.notifications' => 'Notifications',
			'home.backup' => 'Backup',
			'home.export' => 'Export',
			'home.settings' => 'Settings',
			'home.license' => 'License',
			'home.errorSavingDiary' => '日記の保存中にエラーが発生しました',
			'home.errorSavingDiarySolution' => '申し訳ありませんが、入力中のテキストをコピーしてからアプリを再起動してください',
			'home.datePickerCancel' => 'キャンセル',
			'home.datePickerConfirm' => '決定',
			'home.photoSelector.confirm' => '決定',
			'home.photoSelector.noPhotos' => '写真がありません',
			'home.photoSelector.permission.deniedTitle' => '写真ライブラリへのアクセス権限が必要です',
			'home.photoSelector.permission.deniedMessage' => '設定からアプリに写真ライブラリへのアクセスを許可してください',
			'home.photoSelector.permission.openSettings' => '設定を開く',
			'home.photoSelector.notice.title' => '写真の注意点',
			'home.photoSelector.notice.message' => '• 日付ごとに1枚まで添付できます\n• 端末から削除すると表示されません\n• 機種変更で失われる可能性があります\n• クラウド保存は対応予定です',
			'home.photoSelector.notice.confirm' => 'OK',
			'home.photoSelector.error.title' => '画像の保存中にエラーが発生しました',
			'home.photoSelector.error.description' => 'もう一度お試しください',
			'home.deleteImage.title' => '画像を削除',
			'home.deleteImage.message' => 'この画像を削除しますか？',
			'backup.title' => 'Backup',
			'backup.description' => '機種変更でも安心バックアップ',
			'backup.explanation' => 'バックアップファイルが作成できます\n好きなところに保存してください\n（iCloud、Google Drive など）',
			'backup.restoreExplanation' => '保存したバックアップファイルを\n選択して復元できます\n復元時は現在のデータが\n上書きされるため注意してください',
			'backup.successMessage' => 'バックアップが正常に作成されました！',
			'backup.failedMessage' => 'バックアップの作成に失敗しました',
			'backup.restoreFailedMessage' => 'バックアップの復元に失敗しました',
			'backup.restoreSuccess' => '復元が完了しました',
			'backup.actions.create' => 'バックアップを作成',
			'backup.actions.restore' => 'バックアップを復元',
			'backup.actions.goToHome' => 'ホームへ戻る',
			'settings.title' => 'Settings',
			'settings.accessibility' => 'アクセシビリティ',
			'settings.hapticFeedback' => '触覚フィードバック',
			'settings.vibrationSettings' => '振動設定',
			'settings.textInput' => '文字入力',
			'settings.textInputDescription' => '文字入力中の振動設定',
			'settings.other' => 'その他',
			'settings.otherDescription' => 'アイコンタップなどの振動設定',
			'search.searchHint' => '検索キーワードを入力',
			'search.placeholder' => '検索結果がここに表示されます',
			'search.noResults' => '検索結果がありません',
			'notification.title' => 'Notifications',
			'notification.addTime' => '時間を追加',
			'notification.maxTimesReached' => '通知時間は最大3つまでです',
			'notification.channelName' => '日記リマインダー',
			'notification.channelDescription' => '日記を書くための日々のリマインダー',
			'notification.permission.deniedTitle' => '通知権限が必要です',
			'notification.permission.deniedMessage' => 'アプリの通知を有効にするには、端末の設定で通知を許可してください',
			'notification.permission.openSettings' => '設定を開く',
			'notification.notificationTitle' => '今日の日記は書きましたか？',
			'notification.notificationBody' => '1日の出来事や気持ちを書き留めておきましょう',
			'export.title' => 'Export',
			'export.description' => '日記をPDFで出力',
			'export.explanation' => '月ごとに日記をPDFファイルで\nエクスポートできます',
			'export.successMessage' => 'エクスポートが完了しました！',
			'export.failedMessage' => 'エクスポートに失敗しました',
			'export.monthFormat' => 'yyyy年MM月',
			'export.formatSelection' => 'エクスポート形式',
			'export.monthSelection' => '月を選択',
			'export.year' => '年',
			'export.month' => '月',
			'export.comingSoon' => '今後追加予定です',
			'export.actions.exportMonth' => '月別エクスポート',
			'export.actions.export' => 'エクスポート',
			_ => null,
		};
	}
}
