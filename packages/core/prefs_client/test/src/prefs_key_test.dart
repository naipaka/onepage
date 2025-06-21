import 'package:flutter_test/flutter_test.dart';
import 'package:prefs_client/src/prefs_key.dart';

void main() {
  group('PrefsKey', () {
    test('textInputHaptic has correct name', () {
      expect(PrefsKey.textInputHaptic.name, equals('textInputHaptic'));
    });

    test('otherHaptic has correct name', () {
      expect(PrefsKey.otherHaptic.name, equals('otherHaptic'));
    });

    test('all names are unique', () {
      final names = PrefsKey.values.map((e) => e.name).toSet();
      expect(names.length, equals(PrefsKey.values.length));
    });

    test('enum values are correctly defined', () {
      expect(PrefsKey.values, hasLength(2));
      expect(PrefsKey.values, contains(PrefsKey.textInputHaptic));
      expect(PrefsKey.values, contains(PrefsKey.otherHaptic));
    });
  });
}
