import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/src/haptics.dart';
import 'package:mockito/mockito.dart';

import '../utils/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Haptics', () {
    late MockPrefsClient mockPrefsClient;
    late Haptics haptics;
    late List<MethodCall> methodCalls;

    setUp(() {
      mockPrefsClient = MockPrefsClient();
      haptics = Haptics(prefsClient: mockPrefsClient);
      methodCalls = [];

      // Set up method channel to capture haptic feedback calls
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        methodCalls.add(call);
        return null;
      });
    });

    tearDown(() {
      reset(mockPrefsClient);
      methodCalls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    group('constructor', () {
      test('creates instance with PrefsClient', () {
        final instance = Haptics(prefsClient: mockPrefsClient);
        expect(instance, isA<Haptics>());
      });
    });

    group('textInputFeedback', () {
      test('triggers light impact when text input haptic is enabled',
          () async {
        when(mockPrefsClient.textInputHapticEnabled).thenReturn(true);

        await haptics.textInputFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when text input haptic is disabled', () async {
        when(mockPrefsClient.textInputHapticEnabled).thenReturn(false);

        await haptics.textInputFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('buttonTapFeedback', () {
      test('triggers medium impact when other haptic is enabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

        await haptics.buttonTapFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.mediumImpact');
      });

      test('does not trigger when other haptic is disabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(false);

        await haptics.buttonTapFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('toggleFeedback', () {
      test('triggers selection click when other haptic is enabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

        await haptics.toggleFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments,
            'HapticFeedbackType.selectionClick');
      });

      test('does not trigger when other haptic is disabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(false);

        await haptics.toggleFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('navigationFeedback', () {
      test('triggers light impact when other haptic is enabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

        await haptics.navigationFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when other haptic is disabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(false);

        await haptics.navigationFeedback();

        expect(methodCalls, isEmpty);
      });
    });
  });
}
