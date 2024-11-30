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
	@override late final _TranslationsUpdateRequestEn updateRequest = _TranslationsUpdateRequestEn._(_root);
}

// Path: updateRequest
class _TranslationsUpdateRequestEn implements TranslationsUpdateRequestJa {
	_TranslationsUpdateRequestEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Update Request';
	@override late final _TranslationsUpdateRequestButtonEn button = _TranslationsUpdateRequestButtonEn._(_root);
}

// Path: updateRequest.button
class _TranslationsUpdateRequestButtonEn implements TranslationsUpdateRequestButtonJa {
	_TranslationsUpdateRequestButtonEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get updateNow => 'Update Now';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'title': return 'One Page';
			case 'updateRequest.title': return 'Update Request';
			case 'updateRequest.button.updateNow': return 'Update Now';
			default: return null;
		}
	}
}

