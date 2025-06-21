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
  });
}
