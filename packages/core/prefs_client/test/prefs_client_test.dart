import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/mock.mocks.dart';

void main() {
  group('PrefsClient', () {
    late MockSharedPreferences mockSharedPreferences;
    late PrefsClient prefsClient;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      prefsClient = PrefsClient.forTesting(mockSharedPreferences);
    });

    tearDown(() {
      reset(mockSharedPreferences);
    });

    group('initialize', () {
      test('creates PrefsClient instance', () async {
        // This test requires SharedPreferences.setMockInitialValues
        // to avoid platform dependencies
        SharedPreferences.setMockInitialValues({});
        final client = await PrefsClient.initialize();
        expect(client, isA<PrefsClient>());
      });
    });

    group('textInputHapticEnabled', () {
      test('returns false when no value is stored', () {
        when(
          mockSharedPreferences.getBool('textInputHaptic'),
        ).thenReturn(null);

        expect(prefsClient.textInputHapticEnabled, isFalse);
      });

      test('returns stored value when present', () {
        when(
          mockSharedPreferences.getBool('textInputHaptic'),
        ).thenReturn(true);

        expect(prefsClient.textInputHapticEnabled, isTrue);
      });
    });

    group('setTextInputHapticEnabled', () {
      test('stores the provided value', () async {
        when(
          mockSharedPreferences.setBool('textInputHaptic', true),
        ).thenAnswer((_) async => true);

        final result = await prefsClient.setTextInputHapticEnabled(
          enabled: true,
        );

        expect(result, isTrue);
        verify(
          mockSharedPreferences.setBool('textInputHaptic', true),
        ).called(1);
      });

      test('returns false when storage fails', () async {
        when(
          mockSharedPreferences.setBool('textInputHaptic', false),
        ).thenAnswer((_) async => false);

        final result = await prefsClient.setTextInputHapticEnabled(
          enabled: false,
        );

        expect(result, isFalse);
      });
    });

    group('otherHapticEnabled', () {
      test('returns false when no value is stored', () {
        when(mockSharedPreferences.getBool('otherHaptic')).thenReturn(null);

        expect(prefsClient.otherHapticEnabled, isFalse);
      });

      test('returns stored value when present', () {
        when(mockSharedPreferences.getBool('otherHaptic')).thenReturn(true);

        expect(prefsClient.otherHapticEnabled, isTrue);
      });
    });

    group('setOtherHapticEnabled', () {
      test('stores the provided value', () async {
        when(
          mockSharedPreferences.setBool('otherHaptic', true),
        ).thenAnswer((_) async => true);

        final result = await prefsClient.setOtherHapticEnabled(enabled: true);

        expect(result, isTrue);
        verify(mockSharedPreferences.setBool('otherHaptic', true)).called(1);
      });

      test('returns false when storage fails', () async {
        when(
          mockSharedPreferences.setBool('otherHaptic', false),
        ).thenAnswer((_) async => false);

        final result = await prefsClient.setOtherHapticEnabled(enabled: false);

        expect(result, isFalse);
      });
    });

    group('JSON list operations', () {
      group('getNotificationSettings', () {
        test('returns empty list when no value stored', () {
          when(
            mockSharedPreferences.getString('notificationSettings'),
          ).thenReturn(null);

          final result = prefsClient.notificationSettings;
          expect(result, isEmpty);
        });

        test('returns empty list when empty string stored', () {
          when(
            mockSharedPreferences.getString('notificationSettings'),
          ).thenReturn('');

          final result = prefsClient.notificationSettings;
          expect(result, isEmpty);
        });

        test('returns parsed JSON list when valid JSON stored', () {
          final testData = [
            {'id': 1, 'name': 'test1'},
            {'id': 2, 'name': 'test2'},
          ];
          final jsonString = json.encode(testData);

          when(
            mockSharedPreferences.getString('notificationSettings'),
          ).thenReturn(jsonString);

          final result = prefsClient.notificationSettings;
          expect(result, equals(testData));
        });

        test('returns empty list when invalid JSON stored', () {
          when(
            mockSharedPreferences.getString('notificationSettings'),
          ).thenReturn('invalid json');

          final result = prefsClient.notificationSettings;
          expect(result, isEmpty);
        });
      });

      group('setNotificationSettings', () {
        test('stores JSON list successfully', () async {
          final testData = [
            {'id': 1, 'name': 'test1'},
            {'id': 2, 'name': 'test2'},
          ];
          final expectedJson = json.encode(testData);

          when(
            mockSharedPreferences.setString(
              'notificationSettings',
              expectedJson,
            ),
          ).thenAnswer((_) async => true);

          final result = await prefsClient.setNotificationSettings(testData);

          expect(result, isTrue);
          verify(
            mockSharedPreferences.setString(
              'notificationSettings',
              expectedJson,
            ),
          ).called(1);
        });
      });
    });

    group('lastInAppReviewShownAt', () {
      test('returns null when no value is stored', () {
        when(
          mockSharedPreferences.getInt('lastInAppReviewShownAt'),
        ).thenReturn(null);

        expect(prefsClient.lastInAppReviewShownAt, isNull);
      });

      test('returns stored timestamp when value is present', () {
        const testTimestamp = 1704067200; // 2024-01-01 00:00:00 UTC
        when(
          mockSharedPreferences.getInt('lastInAppReviewShownAt'),
        ).thenReturn(testTimestamp);

        final result = prefsClient.lastInAppReviewShownAt;
        expect(result, equals(testTimestamp));
      });
    });

    group('setLastInAppReviewShownAt', () {
      test('stores timestamp successfully', () async {
        const testTimestamp = 1704067200; // 2024-01-01 00:00:00 UTC

        when(
          mockSharedPreferences.setInt(
            'lastInAppReviewShownAt',
            testTimestamp,
          ),
        ).thenAnswer((_) async => true);

        final result = await prefsClient.setLastInAppReviewShownAt(
          timestamp: testTimestamp,
        );

        expect(result, isTrue);
        verify(
          mockSharedPreferences.setInt(
            'lastInAppReviewShownAt',
            testTimestamp,
          ),
        ).called(1);
      });

      test('returns false when storage fails', () async {
        const testTimestamp = 1704067200;
        when(
          mockSharedPreferences.setInt(
            'lastInAppReviewShownAt',
            testTimestamp,
          ),
        ).thenAnswer((_) async => false);

        final result = await prefsClient.setLastInAppReviewShownAt(
          timestamp: testTimestamp,
        );

        expect(result, isFalse);
      });
    });

    group('hasDeclinedInAppReview', () {
      test('returns false when no value is stored', () {
        when(
          mockSharedPreferences.getBool('hasDeclinedInAppReview'),
        ).thenReturn(null);

        expect(prefsClient.hasDeclinedInAppReview, isFalse);
      });

      test('returns stored value when present', () {
        when(
          mockSharedPreferences.getBool('hasDeclinedInAppReview'),
        ).thenReturn(true);

        expect(prefsClient.hasDeclinedInAppReview, isTrue);
      });
    });

    group('setHasDeclinedInAppReview', () {
      test('stores the provided value', () async {
        when(
          mockSharedPreferences.setBool('hasDeclinedInAppReview', true),
        ).thenAnswer((_) async => true);

        final result = await prefsClient.setHasDeclinedInAppReview(
          value: true,
        );

        expect(result, isTrue);
        verify(
          mockSharedPreferences.setBool('hasDeclinedInAppReview', true),
        ).called(1);
      });

      test('returns false when storage fails', () async {
        when(
          mockSharedPreferences.setBool('hasDeclinedInAppReview', false),
        ).thenAnswer((_) async => false);

        final result = await prefsClient.setHasDeclinedInAppReview(
          value: false,
        );

        expect(result, isFalse);
      });
    });
  });
}
