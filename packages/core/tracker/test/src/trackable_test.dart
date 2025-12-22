import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/src/trackable.dart';

void main() {
  group('Trackable', () {
    group('interface', () {
      test('Can create a concrete implementation', () {
        final trackable = TestTrackable();
        expect(trackable, isA<Trackable>());
      });

      test('trackError method exists and can be called', () async {
        final trackable = TestTrackable();
        final error = Exception('Test error');
        final stackTrace = StackTrace.fromString('Test stack trace');

        await trackable.trackError(error, stackTrace);

        expect(trackable.lastError, equals(error));
        expect(trackable.lastStackTrace, equals(stackTrace));
        expect(trackable.lastFatal, isFalse);
      });

      test('trackError method can be called with fatal flag', () async {
        final trackable = TestTrackable();
        final error = Exception('Test error');
        final stackTrace = StackTrace.fromString('Test stack trace');

        await trackable.trackError(error, stackTrace, fatal: true);

        expect(trackable.lastError, equals(error));
        expect(trackable.lastStackTrace, equals(stackTrace));
        expect(trackable.lastFatal, isTrue);
      });

      test('trackScreenView method exists and can be called', () async {
        final trackable = TestTrackable();
        const screenName = 'test_screen';

        await trackable.trackScreenView(screenName);

        expect(trackable.lastScreenName, equals(screenName));
      });

      test('trackEvent method exists and can be called', () async {
        final trackable = TestTrackable();
        const eventName = 'test_event';
        const parameters = {'key': 'value'};

        await trackable.trackEvent(eventName, parameters: parameters);

        expect(trackable.lastEventName, equals(eventName));
        expect(trackable.lastEventParameters, equals(parameters));
      });

      test('trackEvent method can be called without parameters', () async {
        final trackable = TestTrackable();
        const eventName = 'test_event';

        await trackable.trackEvent(eventName);

        expect(trackable.lastEventName, equals(eventName));
        expect(trackable.lastEventParameters, isNull);
      });

      test('setUserId method exists and can be called', () async {
        final trackable = TestTrackable();
        const userId = 'test_user_123';

        await trackable.setUserId(userId);

        expect(trackable.lastUserId, equals(userId));
      });

      test('clearUserId method exists and can be called', () async {
        final trackable = TestTrackable();

        await trackable.clearUserId();

        expect(trackable.userIdCleared, isTrue);
      });
    });
  });
}

/// Test implementation of Trackable for testing purposes
class TestTrackable implements Trackable {
  dynamic lastError;
  StackTrace? lastStackTrace;
  bool lastFatal = false;
  String? lastScreenName;
  String? lastEventName;
  Map<String, Object?>? lastEventParameters;
  String? lastUserId;
  bool userIdCleared = false;

  @override
  Future<void> trackError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    lastError = error;
    lastStackTrace = stackTrace;
    lastFatal = fatal;
  }

  @override
  Future<void> trackScreenView(String screenName) async {
    lastScreenName = screenName;
  }

  @override
  Future<void> trackEvent(
    String name, {
    Map<String, Object?>? parameters,
  }) async {
    lastEventName = name;
    lastEventParameters = parameters;
  }

  @override
  Future<void> setUserId(String userId) async {
    lastUserId = userId;
  }

  @override
  Future<void> clearUserId() async {
    userIdCleared = true;
  }
}
