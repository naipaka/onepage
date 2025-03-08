///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsJa = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
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
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get title => 'One Page';
	String get organization => 'NPK Studio';
	late final TranslationsUpdateRequestJa updateRequest = TranslationsUpdateRequestJa._(_root);
	late final TranslationsHomeJa home = TranslationsHomeJa._(_root);
	late final TranslationsBackupJa backup = TranslationsBackupJa._(_root);
}

// Path: updateRequest
class TranslationsUpdateRequestJa {
	TranslationsUpdateRequestJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'アップデートのお願い';
	late final TranslationsUpdateRequestButtonJa button = TranslationsUpdateRequestButtonJa._(_root);
}

// Path: home
class TranslationsHomeJa {
	TranslationsHomeJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	String get license => 'License';
	String get backup => 'Backup';
	String get errorSavingDiary => '日記の保存中にエラーが発生しました';
	String get errorSavingDiarySolution => '申し訳ありませんが、入力中のテキストをコピーしてからアプリを再起動してください';
}

// Path: backup
class TranslationsBackupJa {
	TranslationsBackupJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Backup';
	String get description => '機種変更でも安心バックアップ';
	String get explanation => 'バックアップファイルが作成できます\n好きなところに保存してください\n（iCloud、Google Drive など）';
	String get restoreExplanation => '保存したバックアップファイルを\n選択して復元できます\n復元時は現在のデータが\n上書きされるため注意してください';
	String get successMessage => 'バックアップが正常に作成されました！';
	String get failedMessage => 'バックアップの作成に失敗しました';
	String get restoreFailedMessage => 'バックアップの復元に失敗しました';
	String get restoreSuccess => '復元が完了しました';
	late final TranslationsBackupActionsJa actions = TranslationsBackupActionsJa._(_root);
}

// Path: updateRequest.button
class TranslationsUpdateRequestButtonJa {
	TranslationsUpdateRequestButtonJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get updateNow => '更新する';
}

// Path: backup.actions
class TranslationsBackupActionsJa {
	TranslationsBackupActionsJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get create => 'バックアップを作成';
	String get restore => 'バックアップを復元';
	String get goToHome => 'ホームへ戻る';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
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
			default: return null;
		}
	}
}

