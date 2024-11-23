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
	late final TranslationsUpdateRequestJa updateRequest = TranslationsUpdateRequestJa._(_root);
	late final TranslationsHomeJa home = TranslationsHomeJa._(_root);
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
	String get today => '今日';
}

// Path: updateRequest.button
class TranslationsUpdateRequestButtonJa {
	TranslationsUpdateRequestButtonJa._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get updateNow => '更新する';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'title': return 'One Page';
			case 'updateRequest.title': return 'アップデートのお願い';
			case 'updateRequest.button.updateNow': return '更新する';
			case 'home.today': return '今日';
			default: return null;
		}
	}
}

