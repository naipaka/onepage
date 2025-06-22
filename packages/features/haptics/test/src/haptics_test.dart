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
      test('triggers light impact when text input haptic is enabled', () async {
        when(mockPrefsClient.textInputHapticEnabled).thenReturn(true);

        haptics.textInputFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when text input haptic is disabled', () async {
        when(mockPrefsClient.textInputHapticEnabled).thenReturn(false);

        haptics.textInputFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('buttonTapFeedback', () {
      test('triggers light impact when other haptic is enabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

        haptics.buttonTapFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when other haptic is disabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(false);

        haptics.buttonTapFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('toggleFeedback', () {
      test('triggers selection click when other haptic is enabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

        haptics.toggleFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(
          methodCalls.first.arguments,
          'HapticFeedbackType.selectionClick',
        );
      });

      test('does not trigger when other haptic is disabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(false);

        haptics.toggleFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('navigationFeedback', () {
      test('triggers light impact when other haptic is enabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

        haptics.navigationFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when other haptic is disabled', () async {
        when(mockPrefsClient.otherHapticEnabled).thenReturn(false);

        haptics.navigationFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('successFeedback', () {
      test(
        'triggers first medium impact immediately when other haptic is enabled',
        () async {
          final localMethodCalls = <MethodCall>[];

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(SystemChannels.platform, (call) async {
                localMethodCalls.add(call);
                return null;
              });

          when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

          haptics.successFeedback();

          // First impact should be immediate
          expect(localMethodCalls, hasLength(1));
          expect(localMethodCalls.first.method, 'HapticFeedback.vibrate');
          expect(
            localMethodCalls.first.arguments,
            'HapticFeedbackType.mediumImpact',
          );

          // Clean up
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(SystemChannels.platform, null);

          // Wait for any pending futures to complete
          await Future<void>.delayed(const Duration(milliseconds: 250));
        },
      );

      test(
        'triggers double medium impact with delay when other haptic is enabled',
        () async {
          final localMethodCalls = <MethodCall>[];

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(SystemChannels.platform, (call) async {
                localMethodCalls.add(call);
                return null;
              });

          when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

          haptics.successFeedback();

          // First impact should be immediate
          expect(localMethodCalls, hasLength(1));
          expect(localMethodCalls.first.method, 'HapticFeedback.vibrate');
          expect(
            localMethodCalls.first.arguments,
            'HapticFeedbackType.mediumImpact',
          );

          await Future<void>.delayed(const Duration(milliseconds: 220));

          // Second impact should be triggered after delay
          expect(localMethodCalls, hasLength(2));
          expect(localMethodCalls[1].method, 'HapticFeedback.vibrate');
          expect(
            localMethodCalls[1].arguments,
            'HapticFeedbackType.mediumImpact',
          );

          // Clean up
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(SystemChannels.platform, null);
        },
      );

      test('does not trigger when other haptic is disabled', () async {
        final localMethodCalls = <MethodCall>[];

        // Set up method channel to capture haptic feedback calls for this test
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (call) async {
              localMethodCalls.add(call);
              return null;
            });

        when(mockPrefsClient.otherHapticEnabled).thenReturn(false);

        haptics.successFeedback();

        expect(localMethodCalls, isEmpty);

        // Clean up
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);

        // Wait for any pending futures to complete
        await Future<void>.delayed(const Duration(milliseconds: 250));
      });
    });
  });
}
