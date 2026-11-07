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
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override String get title => 'One Page';
	@override String get organization => 'NPK Studio';
	@override late final _Translations$updateRequest$ja updateRequest = _Translations$updateRequest$ja._(_root);
	@override late final _Translations$home$ja home = _Translations$home$ja._(_root);
	@override late final _Translations$photoRecovery$ja photoRecovery = _Translations$photoRecovery$ja._(_root);
	@override late final _Translations$backup$ja backup = _Translations$backup$ja._(_root);
	@override late final _Translations$settings$ja settings = _Translations$settings$ja._(_root);
	@override late final _Translations$search$ja search = _Translations$search$ja._(_root);
	@override late final _Translations$notification$ja notification = _Translations$notification$ja._(_root);
	@override late final _Translations$export$ja export = _Translations$export$ja._(_root);
}

// Path: updateRequest
class _Translations$updateRequest$ja implements Translations$updateRequest$en {
	_Translations$updateRequest$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アップデートのお願い';
	@override late final _Translations$updateRequest$button$ja button = _Translations$updateRequest$button$ja._(_root);
}

// Path: home
class _Translations$home$ja implements Translations$home$en {
	_Translations$home$ja._(this._root);

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
	@override late final _Translations$home$photoSelector$ja photoSelector = _Translations$home$photoSelector$ja._(_root);
	@override late final _Translations$home$deleteImage$ja deleteImage = _Translations$home$deleteImage$ja._(_root);
}

// Path: photoRecovery
class _Translations$photoRecovery$ja implements Translations$photoRecovery$en {
	_Translations$photoRecovery$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '写真の復旧';
	@override String get banner => '復旧が必要な写真があります';
	@override String remaining({required Object count}) => '残りの写真: ${count} 枚';
	@override String get progress => '写真を復旧しています';
	@override late final _Translations$photoRecovery$folder$ja folder = _Translations$photoRecovery$folder$ja._(_root);
	@override late final _Translations$photoRecovery$settings$ja settings = _Translations$photoRecovery$settings$ja._(_root);
	@override String get remind => '復旧する';
	@override String get missing => '元の写真がこの端末に見つかりませんでした';
	@override String get deletePhoto => 'この写真を削除';
	@override late final _Translations$photoRecovery$deleteConfirm$ja deleteConfirm = _Translations$photoRecovery$deleteConfirm$ja._(_root);
	@override late final _Translations$photoRecovery$deleteUnrecovered$ja deleteUnrecovered = _Translations$photoRecovery$deleteUnrecovered$ja._(_root);
	@override late final _Translations$photoRecovery$dismiss$ja dismiss = _Translations$photoRecovery$dismiss$ja._(_root);
	@override String recovered({required Object count}) => '${count} 枚の写真を復旧しました';
	@override String get failed => '写真を復旧できませんでした';
}

// Path: backup
class _Translations$backup$ja implements Translations$backup$en {
	_Translations$backup$ja._(this._root);

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
	@override late final _Translations$backup$progress$ja progress = _Translations$backup$progress$ja._(_root);
	@override late final _Translations$backup$legacyRestore$ja legacyRestore = _Translations$backup$legacyRestore$ja._(_root);
	@override late final _Translations$backup$actions$ja actions = _Translations$backup$actions$ja._(_root);
}

// Path: settings
class _Translations$settings$ja implements Translations$settings$en {
	_Translations$settings$ja._(this._root);

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
class _Translations$search$ja implements Translations$search$en {
	_Translations$search$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get searchHint => '検索キーワードを入力';
	@override String get placeholder => '検索結果がここに表示されます';
	@override String get noResults => '検索結果がありません';
}

// Path: notification
class _Translations$notification$ja implements Translations$notification$en {
	_Translations$notification$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifications';
	@override String get addTime => '時間を追加';
	@override String get maxTimesReached => '通知時間は最大3つまでです';
	@override String get channelName => '日記リマインダー';
	@override String get channelDescription => '日記を書くための日々のリマインダー';
	@override late final _Translations$notification$permission$ja permission = _Translations$notification$permission$ja._(_root);
	@override String get notificationTitle => '今日の日記は書きましたか？';
	@override String get notificationBody => '1日の出来事や気持ちを書き留めておきましょう';
}

// Path: export
class _Translations$export$ja implements Translations$export$en {
	_Translations$export$ja._(this._root);

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
	@override late final _Translations$export$actions$ja actions = _Translations$export$actions$ja._(_root);
}

// Path: updateRequest.button
class _Translations$updateRequest$button$ja implements Translations$updateRequest$button$en {
	_Translations$updateRequest$button$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get updateNow => '更新する';
}

// Path: home.photoSelector
class _Translations$home$photoSelector$ja implements Translations$home$photoSelector$en {
	_Translations$home$photoSelector$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$home$photoSelector$notice$ja notice = _Translations$home$photoSelector$notice$ja._(_root);
	@override late final _Translations$home$photoSelector$error$ja error = _Translations$home$photoSelector$error$ja._(_root);
}

// Path: home.deleteImage
class _Translations$home$deleteImage$ja implements Translations$home$deleteImage$en {
	_Translations$home$deleteImage$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '画像を削除';
	@override String get message => 'この画像を削除しますか？';
}

// Path: photoRecovery.folder
class _Translations$photoRecovery$folder$ja implements Translations$photoRecovery$folder$en {
	_Translations$photoRecovery$folder$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get message => '写真が保存されているフォルダを選んでください（DCIM や Pictures など）\n必要な写真だけをコピーし、元の写真はそのまま残ります';
	@override String get action => 'フォルダを選ぶ';
}

// Path: photoRecovery.settings
class _Translations$photoRecovery$settings$ja implements Translations$photoRecovery$settings$en {
	_Translations$photoRecovery$settings$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get message => '設定ですべての写真へのアクセスを許可してから、もう一度お試しください';
	@override String get action => '設定を開く';
	@override String get retry => 'もう一度試す';
}

// Path: photoRecovery.deleteConfirm
class _Translations$photoRecovery$deleteConfirm$ja implements Translations$photoRecovery$deleteConfirm$en {
	_Translations$photoRecovery$deleteConfirm$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '写真の削除';
	@override String get message => 'この写真を日記から削除しますか？';
}

// Path: photoRecovery.deleteUnrecovered
class _Translations$photoRecovery$deleteUnrecovered$ja implements Translations$photoRecovery$deleteUnrecovered$en {
	_Translations$photoRecovery$deleteUnrecovered$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get action => '表示されない写真を日記から削除';
	@override String get title => '表示されない写真を削除しますか？';
	@override String message({required Object count}) => 'アルバムから消した写真や、機種変更で移していない写真は表示できません\n表示されていない ${count} 枚の写真を日記から削除します';
}

// Path: photoRecovery.dismiss
class _Translations$photoRecovery$dismiss$ja implements Translations$photoRecovery$dismiss$en {
	_Translations$photoRecovery$dismiss$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get action => '残りの写真を復旧しない';
	@override String get title => '写真の復旧をやめますか？';
	@override String get message => '復旧のお知らせが表示されなくなります\nメニューからはいつでも復旧できます';
}

// Path: backup.progress
class _Translations$backup$progress$ja implements Translations$backup$progress$en {
	_Translations$backup$progress$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get creating => 'バックアップを作成しています';
	@override String get restoring => 'バックアップを復元しています';
}

// Path: backup.legacyRestore
class _Translations$backup$legacyRestore$ja implements Translations$backup$legacyRestore$en {
	_Translations$backup$legacyRestore$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '写真が含まれていません';
	@override String get message => '古い形式のバックアップです\n復元すると、現在の日記と写真はバックアップの内容に置き換わります';
	@override String get confirm => '復元する';
	@override String get cancel => 'キャンセル';
}

// Path: backup.actions
class _Translations$backup$actions$ja implements Translations$backup$actions$en {
	_Translations$backup$actions$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get create => 'バックアップを作成';
	@override String get restore => 'バックアップを復元';
	@override String get goToHome => 'ホームへ戻る';
}

// Path: notification.permission
class _Translations$notification$permission$ja implements Translations$notification$permission$en {
	_Translations$notification$permission$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get deniedTitle => '通知権限が必要です';
	@override String get deniedMessage => 'アプリの通知を有効にするには、端末の設定で通知を許可してください';
	@override String get openSettings => '設定を開く';
}

// Path: export.actions
class _Translations$export$actions$ja implements Translations$export$actions$en {
	_Translations$export$actions$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get exportMonth => '月別エクスポート';
	@override String get export => 'エクスポート';
}

// Path: home.photoSelector.notice
class _Translations$home$photoSelector$notice$ja implements Translations$home$photoSelector$notice$en {
	_Translations$home$photoSelector$notice$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '写真の注意点';
	@override String get message => '• 日付ごとに1枚まで添付できます\n• 機種変更で失われる可能性があります\n• クラウド保存は将来的に対応予定です';
	@override String get confirm => 'OK';
}

// Path: home.photoSelector.error
class _Translations$home$photoSelector$error$ja implements Translations$home$photoSelector$error$en {
	_Translations$home$photoSelector$error$ja._(this._root);

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
			'home.photoSelector.notice.title' => '写真の注意点',
			'home.photoSelector.notice.message' => '• 日付ごとに1枚まで添付できます\n• 機種変更で失われる可能性があります\n• クラウド保存は将来的に対応予定です',
			'home.photoSelector.notice.confirm' => 'OK',
			'home.photoSelector.error.title' => '画像の保存中にエラーが発生しました',
			'home.photoSelector.error.description' => 'もう一度お試しください',
			'home.deleteImage.title' => '画像を削除',
			'home.deleteImage.message' => 'この画像を削除しますか？',
			'photoRecovery.title' => '写真の復旧',
			'photoRecovery.banner' => '復旧が必要な写真があります',
			'photoRecovery.remaining' => ({required Object count}) => '残りの写真: ${count} 枚',
			'photoRecovery.progress' => '写真を復旧しています',
			'photoRecovery.folder.message' => '写真が保存されているフォルダを選んでください（DCIM や Pictures など）\n必要な写真だけをコピーし、元の写真はそのまま残ります',
			'photoRecovery.folder.action' => 'フォルダを選ぶ',
			'photoRecovery.settings.message' => '設定ですべての写真へのアクセスを許可してから、もう一度お試しください',
			'photoRecovery.settings.action' => '設定を開く',
			'photoRecovery.settings.retry' => 'もう一度試す',
			'photoRecovery.remind' => '復旧する',
			'photoRecovery.missing' => '元の写真がこの端末に見つかりませんでした',
			'photoRecovery.deletePhoto' => 'この写真を削除',
			'photoRecovery.deleteConfirm.title' => '写真の削除',
			'photoRecovery.deleteConfirm.message' => 'この写真を日記から削除しますか？',
			'photoRecovery.deleteUnrecovered.action' => '表示されない写真を日記から削除',
			'photoRecovery.deleteUnrecovered.title' => '表示されない写真を削除しますか？',
			'photoRecovery.deleteUnrecovered.message' => ({required Object count}) => 'アルバムから消した写真や、機種変更で移していない写真は表示できません\n表示されていない ${count} 枚の写真を日記から削除します',
			'photoRecovery.dismiss.action' => '残りの写真を復旧しない',
			'photoRecovery.dismiss.title' => '写真の復旧をやめますか？',
			'photoRecovery.dismiss.message' => '復旧のお知らせが表示されなくなります\nメニューからはいつでも復旧できます',
			'photoRecovery.recovered' => ({required Object count}) => '${count} 枚の写真を復旧しました',
			'photoRecovery.failed' => '写真を復旧できませんでした',
			'backup.title' => 'Backup',
			'backup.description' => '機種変更でも安心バックアップ',
			'backup.explanation' => 'バックアップファイルが作成できます\n好きなところに保存してください\n（iCloud、Google Drive など）',
			'backup.restoreExplanation' => '保存したバックアップファイルを\n選択して復元できます\n復元時は現在のデータが\n上書きされるため注意してください',
			'backup.successMessage' => 'バックアップが正常に作成されました！',
			'backup.failedMessage' => 'バックアップの作成に失敗しました',
			'backup.restoreFailedMessage' => 'バックアップの復元に失敗しました',
			'backup.restoreSuccess' => '復元が完了しました',
			'backup.progress.creating' => 'バックアップを作成しています',
			'backup.progress.restoring' => 'バックアップを復元しています',
			'backup.legacyRestore.title' => '写真が含まれていません',
			'backup.legacyRestore.message' => '古い形式のバックアップです\n復元すると、現在の日記と写真はバックアップの内容に置き換わります',
			'backup.legacyRestore.confirm' => '復元する',
			'backup.legacyRestore.cancel' => 'キャンセル',
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
