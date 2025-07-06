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
class TranslationsJa implements Translations {
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
	@override String get license => 'License';
	@override String get backup => 'Backup';
	@override String get errorSavingDiary => '日記の保存中にエラーが発生しました';
	@override String get errorSavingDiarySolution => '申し訳ありませんが、入力中のテキストをコピーしてからアプリを再起動してください';
	@override String get datePickerCancel => 'キャンセル';
	@override String get datePickerConfirm => '決定';
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

// Path: updateRequest.button
class _TranslationsUpdateRequestButtonJa implements TranslationsUpdateRequestButtonEn {
	_TranslationsUpdateRequestButtonJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get updateNow => '更新する';
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

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'title': return 'One Page';
			case 'organization': return 'NPK Studio';
			case 'updateRequest.title': return 'アップデートのお願い';
			case 'updateRequest.button.updateNow': return '更新する';
			case 'home.title': return 'Home';
			case 'home.license': return 'License';
			case 'home.backup': return 'Backup';
			case 'home.errorSavingDiary': return '日記の保存中にエラーが発生しました';
			case 'home.errorSavingDiarySolution': return '申し訳ありませんが、入力中のテキストをコピーしてからアプリを再起動してください';
			case 'home.datePickerCancel': return 'キャンセル';
			case 'home.datePickerConfirm': return '決定';
			case 'backup.title': return 'Backup';
			case 'backup.description': return '機種変更でも安心バックアップ';
			case 'backup.explanation': return 'バックアップファイルが作成できます\n好きなところに保存してください\n（iCloud、Google Drive など）';
			case 'backup.restoreExplanation': return '保存したバックアップファイルを\n選択して復元できます\n復元時は現在のデータが\n上書きされるため注意してください';
			case 'backup.successMessage': return 'バックアップが正常に作成されました！';
			case 'backup.failedMessage': return 'バックアップの作成に失敗しました';
			case 'backup.restoreFailedMessage': return 'バックアップの復元に失敗しました';
			case 'backup.restoreSuccess': return '復元が完了しました';
			case 'backup.actions.create': return 'バックアップを作成';
			case 'backup.actions.restore': return 'バックアップを復元';
			case 'backup.actions.goToHome': return 'ホームへ戻る';
			case 'settings.title': return 'Settings';
			case 'settings.accessibility': return 'アクセシビリティ';
			case 'settings.hapticFeedback': return '触覚フィードバック';
			case 'settings.vibrationSettings': return '振動設定';
			case 'settings.textInput': return '文字入力';
			case 'settings.textInputDescription': return '文字入力中の振動設定';
			case 'settings.other': return 'その他';
			case 'settings.otherDescription': return 'アイコンタップなどの振動設定';
			case 'search.searchHint': return '検索キーワードを入力';
			case 'search.placeholder': return '検索結果がここに表示されます';
			case 'search.noResults': return '検索結果がありません';
			case 'notification.title': return 'Notifications';
			case 'notification.addTime': return '時間を追加';
			case 'notification.maxTimesReached': return '通知時間は最大3つまでです';
			case 'notification.channelName': return '日記リマインダー';
			case 'notification.channelDescription': return '日記を書くための日々のリマインダー';
			case 'notification.permission.deniedTitle': return '通知権限が必要です';
			case 'notification.permission.deniedMessage': return 'アプリの通知を有効にするには、端末の設定で通知を許可してください';
			case 'notification.permission.openSettings': return '設定を開く';
			case 'notification.notificationTitle': return '今日の日記は書きましたか？';
			case 'notification.notificationBody': return '1日の出来事や気持ちを書き留めておきましょう';
			default: return null;
		}
	}
}

