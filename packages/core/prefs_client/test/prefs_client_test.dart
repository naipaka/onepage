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

    group('skip notification if diary exists', () {
      group('skipNotificationIfDiaryExists', () {
        test('returns false when no value stored', () {
          when(
            mockSharedPreferences.getBool('skipNotificationIfDiaryExists'),
          ).thenReturn(null);

          expect(prefsClient.skipNotificationIfDiaryExists, isFalse);
        });

        test('returns stored value when present', () {
          when(
            mockSharedPreferences.getBool('skipNotificationIfDiaryExists'),
          ).thenReturn(true);

          expect(prefsClient.skipNotificationIfDiaryExists, isTrue);
        });
      });

      group('setSkipNotificationIfDiaryExists', () {
        test('stores the provided value', () async {
          when(
            mockSharedPreferences.setBool(
              'skipNotificationIfDiaryExists',
              true,
            ),
          ).thenAnswer((_) async => true);

          final result = await prefsClient.setSkipNotificationIfDiaryExists(
            skip: true,
          );

          expect(result, isTrue);
          verify(
            mockSharedPreferences.setBool(
              'skipNotificationIfDiaryExists',
              true,
            ),
          ).called(1);
        });
      });
    });
  });
}
