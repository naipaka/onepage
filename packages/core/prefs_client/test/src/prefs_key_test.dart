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

    test('notificationSettings has correct name', () {
      expect(
        PrefsKey.notificationSettings.name,
        equals('notificationSettings'),
      );
    });

    test('all names are unique', () {
      final names = PrefsKey.values.map((e) => e.name).toSet();
      expect(names.length, equals(PrefsKey.values.length));
    });

    test('lastInAppReviewShownAt has correct name', () {
      expect(
        PrefsKey.lastInAppReviewShownAt.name,
        equals('lastInAppReviewShownAt'),
      );
    });

    test('hasDeclinedInAppReview has correct name', () {
      expect(
        PrefsKey.hasDeclinedInAppReview.name,
        equals('hasDeclinedInAppReview'),
      );
    });

    test('enum values are correctly defined', () {
      expect(PrefsKey.values, hasLength(5));
      expect(PrefsKey.values, contains(PrefsKey.textInputHaptic));
      expect(PrefsKey.values, contains(PrefsKey.otherHaptic));
      expect(PrefsKey.values, contains(PrefsKey.notificationSettings));
      expect(PrefsKey.values, contains(PrefsKey.lastInAppReviewShownAt));
      expect(PrefsKey.values, contains(PrefsKey.hasDeclinedInAppReview));
    });
  });
}
