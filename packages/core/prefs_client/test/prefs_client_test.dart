import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PrefsClient', () {
    late PrefsClient prefsClient;
    late SharedPreferences prefs;

    Future<void> setUpStoredValues(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      prefsClient = await PrefsClient.initialize();
      prefs = await SharedPreferences.getInstance();
    }

    setUp(() => setUpStoredValues({}));

    group('textInputHapticEnabled', () {
      test('returns false when no value is stored', () {
        expect(prefsClient.textInputHapticEnabled, isFalse);
      });

      test('returns the stored value', () async {
        await setUpStoredValues({'textInputHaptic': true});

        expect(prefsClient.textInputHapticEnabled, isTrue);
      });

      test('stores the value', () async {
        final result = await prefsClient.setTextInputHapticEnabled(
          enabled: true,
        );

        expect(result, isTrue);
        expect(prefs.getBool('textInputHaptic'), isTrue);
        expect(prefsClient.textInputHapticEnabled, isTrue);
      });
    });

    group('otherHapticEnabled', () {
      test('returns false when no value is stored', () {
        expect(prefsClient.otherHapticEnabled, isFalse);
      });

      test('returns the stored value', () async {
        await setUpStoredValues({'otherHaptic': true});

        expect(prefsClient.otherHapticEnabled, isTrue);
      });

      test('stores the value', () async {
        final result = await prefsClient.setOtherHapticEnabled(enabled: true);

        expect(result, isTrue);
        expect(prefs.getBool('otherHaptic'), isTrue);
        expect(prefsClient.otherHapticEnabled, isTrue);
      });
    });

    group('photoRecoveryDismissed', () {
      test('returns false when no value is stored', () {
        expect(prefsClient.photoRecoveryDismissed, isFalse);
      });

      test('stores the value', () async {
        final result = await prefsClient.setPhotoRecoveryDismissed(
          dismissed: true,
        );

        expect(result, isTrue);
        expect(prefs.getBool('photoRecoveryDismissed'), isTrue);
        expect(prefsClient.photoRecoveryDismissed, isTrue);
      });
    });

    group('notificationSettings', () {
      final settings = [
        {'id': 1, 'hour': 8, 'isEnabled': true},
        {'id': 2, 'hour': 20, 'isEnabled': false},
      ];

      test('returns an empty list when no value is stored', () {
        expect(prefsClient.notificationSettings, isEmpty);
      });

      test('returns an empty list when an empty string is stored', () async {
        await setUpStoredValues({'notificationSettings': ''});

        expect(prefsClient.notificationSettings, isEmpty);
      });

      test('returns the stored JSON list', () async {
        await setUpStoredValues({
          'notificationSettings': json.encode(settings),
        });

        expect(prefsClient.notificationSettings, settings);
      });

      test('returns an empty list when the stored value is not JSON', () async {
        await setUpStoredValues({'notificationSettings': 'invalid json'});

        expect(prefsClient.notificationSettings, isEmpty);
      });

      test('stores the list as JSON', () async {
        final result = await prefsClient.setNotificationSettings(settings);

        expect(result, isTrue);
        expect(prefs.getString('notificationSettings'), json.encode(settings));
        expect(prefsClient.notificationSettings, settings);
      });
    });

    group('hasDeclinedInAppReview', () {
      test('returns false when no value is stored', () {
        expect(prefsClient.hasDeclinedInAppReview, isFalse);
      });

      test('stores the value', () async {
        final result = await prefsClient.setHasDeclinedInAppReview(value: true);

        expect(result, isTrue);
        expect(prefs.getBool('hasDeclinedInAppReview'), isTrue);
        expect(prefsClient.hasDeclinedInAppReview, isTrue);
      });
    });

    group('lastInAppReviewShownAt', () {
      const timestamp = 1704067200;

      test('returns null when no value is stored', () {
        expect(prefsClient.lastInAppReviewShownAt, isNull);
      });

      test('stores the timestamp', () async {
        final result = await prefsClient.setLastInAppReviewShownAt(
          timestamp: timestamp,
        );

        expect(result, isTrue);
        expect(prefs.getInt('lastInAppReviewShownAt'), timestamp);
        expect(prefsClient.lastInAppReviewShownAt, timestamp);
      });
    });

    group('hasShownDiaryImageNotice', () {
      test('returns false when no value is stored', () {
        expect(prefsClient.hasShownDiaryImageNotice, isFalse);
      });

      test('stores the value', () async {
        final result = await prefsClient.setHasShownDiaryImageNotice(
          shown: true,
        );

        expect(result, isTrue);
        expect(prefs.getBool('diaryImageNoticeShown'), isTrue);
        expect(prefsClient.hasShownDiaryImageNotice, isTrue);
      });
    });
  });
}
