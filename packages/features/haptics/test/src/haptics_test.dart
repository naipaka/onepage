import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/src/haptics.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Haptics', () {
    late Haptics haptics;
    late List<MethodCall> methodCalls;

    Future<void> setUpPrefs(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      haptics = Haptics(prefsClient: await PrefsClient.initialize());
    }

    setUp(() async {
      await setUpPrefs({});
      methodCalls = [];

      // Set up method channel to capture haptic feedback calls
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            methodCalls.add(call);
            return null;
          });
    });

    tearDown(() {
      methodCalls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    group('textInputFeedback', () {
      test('triggers light impact when text input haptic is enabled', () async {
        await setUpPrefs({'textInputHaptic': true});

        haptics.textInputFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when text input haptic is disabled', () async {
        await setUpPrefs({'textInputHaptic': false});

        haptics.textInputFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('buttonTapFeedback', () {
      test('triggers light impact when other haptic is enabled', () async {
        await setUpPrefs({'otherHaptic': true});

        haptics.buttonTapFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when other haptic is disabled', () async {
        await setUpPrefs({'otherHaptic': false});

        haptics.buttonTapFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('toggleFeedback', () {
      test('triggers selection click when other haptic is enabled', () async {
        await setUpPrefs({'otherHaptic': true});

        haptics.toggleFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(
          methodCalls.first.arguments,
          'HapticFeedbackType.selectionClick',
        );
      });

      test('does not trigger when other haptic is disabled', () async {
        await setUpPrefs({'otherHaptic': false});

        haptics.toggleFeedback();

        expect(methodCalls, isEmpty);
      });
    });

    group('navigationFeedback', () {
      test('triggers light impact when other haptic is enabled', () async {
        await setUpPrefs({'otherHaptic': true});

        haptics.navigationFeedback();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'HapticFeedback.vibrate');
        expect(methodCalls.first.arguments, 'HapticFeedbackType.lightImpact');
      });

      test('does not trigger when other haptic is disabled', () async {
        await setUpPrefs({'otherHaptic': false});

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

          await setUpPrefs({'otherHaptic': true});

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

          await setUpPrefs({'otherHaptic': true});

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

        await setUpPrefs({'otherHaptic': false});

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
