import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracker/tracker.dart';

import '../utils/mock.dart';

void main() {
  group('Tracker', () {
    group('constructor', () {
      test('Can create an instance', () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        setupFirebaseCoreMocks();
        await Firebase.initializeApp();

        final tracker = Tracker();
        expect(tracker, isA<Tracker>());
      });

      test('Can create an instance with custom trackers', () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        setupFirebaseCoreMocks();
        await Firebase.initializeApp();

        final mockTracker = MockTrackable();
        final tracker = Tracker(trackers: [mockTracker]);
        expect(tracker, isA<Tracker>());
      });

      test('Can create an instance for testing', () {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final mockTracker = MockTrackable();

        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
          trackers: [mockTracker],
        );

        expect(tracker, isA<Tracker>());
      });
    });

    test(
      'onFlutterError should record a fatal error on crashlytics and trackers',
      () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final trackable = MockTrackable();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
          trackers: [trackable],
        );

        final exception = Exception('Test exception');
        final stack = StackTrace.fromString('Test stack trace');
        final flutterErrorDetails = FlutterErrorDetails(
          exception: exception,
          stack: stack,
        );
        when(
          () => crashlytics.recordFlutterFatalError(flutterErrorDetails),
        ).thenAnswer((_) async {});
        when(
          () => trackable.trackError(exception, stack, fatal: true),
        ).thenAnswer((_) async {});

        await tracker.onFlutterError(flutterErrorDetails);

        verify(
          () => crashlytics.recordFlutterFatalError(flutterErrorDetails),
        ).called(1);
        verify(
          () => trackable.trackError(exception, stack, fatal: true),
        ).called(1);
        verifyNoMoreInteractions(crashlytics);
        verifyNoMoreInteractions(analytics);
        verifyNoMoreInteractions(trackable);
      },
    );

    test(
      'onPlatformError should call recordError on crashlytics and trackers',
      () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final trackable = MockTrackable();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
          trackers: [trackable],
        );

        final error = Exception('Test exception');
        final stack = StackTrace.fromString('Test stack trace');
        when(
          () => crashlytics.recordError(error, stack, fatal: true),
        ).thenAnswer((_) async {});
        when(
          () => trackable.trackError(error, stack, fatal: true),
        ).thenAnswer((_) async {});

        final got = tracker.onPlatformError(error, stack);

        expect(got, true);
        verify(() => crashlytics.recordError(error, stack, fatal: true))
            .called(1);
        verify(() => trackable.trackError(error, stack, fatal: true)).called(1);
        verifyNoMoreInteractions(crashlytics);
        verifyNoMoreInteractions(analytics);
        verifyNoMoreInteractions(trackable);
      },
    );

    test('isolateErrorListener should call recordError '
        'on crashlytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker.forTesting(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      final error = Exception('Test exception');
      final stack = StackTrace.fromString('Test stack trace');
      when(
        () => crashlytics.recordError(
          any<Object?>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => trackable.trackError(
          any<Object?>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});

      final got = tracker.isolateErrorListener();

      expect(got, isA<SendPort>());

      got.send([error, stack]);

      await pumpEventQueue();

      verify(
        () => crashlytics.recordError(
          any<Object?>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).called(1);
      verify(
        () => trackable.trackError(
          any<Object?>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test(
      'recordError should record a non-fatal error on crashlytics and trackers',
      () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final trackable = MockTrackable();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
          trackers: [trackable],
        );

        final error = Exception('Test exception');
        final stack = StackTrace.fromString('Test stack trace');
        when(
          () => crashlytics.recordError(error, stack),
        ).thenAnswer((_) async {});
        when(
          () => trackable.trackError(error, stack, fatal: false),
        ).thenAnswer((_) async {});

        await tracker.recordError(error, stack);

        verify(() => crashlytics.recordError(error, stack)).called(1);
        verify(
          () => trackable.trackError(error, stack, fatal: false),
        ).called(1);
        verifyNoMoreInteractions(crashlytics);
        verifyNoMoreInteractions(analytics);
        verifyNoMoreInteractions(trackable);
      },
    );

    group('setErrorReportingEnabled', () {
      test('turns on reporting to crashlytics', () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
        );
        when(
          () => crashlytics.setCrashlyticsCollectionEnabled(true),
        ).thenAnswer((_) async {});

        await tracker.setErrorReportingEnabled(enabled: true);

        verify(() => crashlytics.setCrashlyticsCollectionEnabled(true))
            .called(1);
        verifyNoMoreInteractions(crashlytics);
        verifyNoMoreInteractions(analytics);
      });

      test('turns off reporting and deletes unsent reports', () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
        );
        when(
          () => crashlytics.setCrashlyticsCollectionEnabled(false),
        ).thenAnswer((_) async {});
        when(crashlytics.deleteUnsentReports).thenAnswer((_) async {});

        await tracker.setErrorReportingEnabled(enabled: false);

        verifyInOrder([
          () => crashlytics.setCrashlyticsCollectionEnabled(false),
          crashlytics.deleteUnsentReports,
        ]);
        verifyNoMoreInteractions(crashlytics);
        verifyNoMoreInteractions(analytics);
      });
    });

    test('setUserId should call setUserIdentifier '
        'on crashlytics, analytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker.forTesting(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const userId = 'b979be1991444eeb814acdccd594';
      when(() => crashlytics.setUserIdentifier(userId))
          .thenAnswer((_) async {});
      when(() => analytics.setUserId(id: userId)).thenAnswer((_) async {});
      when(() => trackable.setUserId(userId)).thenAnswer((_) async {});

      await tracker.setUserId(userId);

      verify(() => crashlytics.setUserIdentifier(userId)).called(1);
      verify(() => analytics.setUserId(id: userId)).called(1);
      verify(() => trackable.setUserId(userId)).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test('clearUserId should call setUserIdentifier '
        'on crashlytics, analytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker.forTesting(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const userId = '';
      when(() => crashlytics.setUserIdentifier(userId))
          .thenAnswer((_) async {});
      when(analytics.setUserId).thenAnswer((_) async {});
      when(trackable.clearUserId).thenAnswer((_) async {});

      await tracker.clearUserId();

      verify(() => crashlytics.setUserIdentifier(userId)).called(1);
      verify(analytics.setUserId).called(1);
      verify(trackable.clearUserId).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test(
      'setUserProperties should call setUserProperty on analytics',
      () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
        );

        const properties = {'key': 'value'};
        when(
          () => analytics.setUserProperty(
            name: any(named: 'name'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await tracker.setUserProperties(properties);

        verify(
          () => analytics.setUserProperty(
            name: any(named: 'name'),
            value: any(named: 'value'),
          ),
        ).called(1);
        verifyNoMoreInteractions(crashlytics);
        verifyNoMoreInteractions(analytics);
      },
    );

    test(
      'navigatorObserver should return a FirebaseAnalyticsObserver',
      () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
        );

        String nameExtractor(RouteSettings settings) => settings.name!;
        bool routerFilter(Route<dynamic>? route) => route != null;
        final got = tracker.navigatorObserver(
          nameExtractor: nameExtractor,
          routeFilter: routerFilter,
        );

        expect(got, isA<NavigatorObserver>());
        expect(got, isA<FirebaseAnalyticsObserver>());
      },
    );

    test(
      'navigatorObservers should return a list of NavigatorObservers',
      () async {
        final crashlytics = MockFirebaseCrashlytics();
        final analytics = MockFirebaseAnalytics();
        final tracker = Tracker.forTesting(
          crashlytics: crashlytics,
          analytics: analytics,
        );

        String nameExtractor(RouteSettings settings) => settings.name!;
        bool routerFilter(Route<dynamic>? route) => route != null;
        final got = tracker.navigatorObservers(
          nameExtractor: nameExtractor,
          routeFilter: routerFilter,
        );

        expect(got, isA<List<NavigatorObserver>>());
        expect(
          got.whereType<FirebaseAnalyticsObserver>(),
          hasLength(1),
        );
      },
    );

    test('trackScreenView should call setCurrentScreen on analytics', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker.forTesting(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const screenName = 'screen';
      when(
        () => analytics.logScreenView(
          screenName: screenName,
        ),
      ).thenAnswer((_) async {});
      when(() => trackable.trackScreenView(screenName))
          .thenAnswer((_) async {});

      await tracker.trackScreenView(screenName);

      verify(
        () => analytics.logScreenView(
          screenName: screenName,
        ),
      ).called(1);
      verify(() => trackable.trackScreenView(screenName)).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
    });

    test('logEvent should call logEvent on analytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker.forTesting(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const eventName = 'event';
      const parameters = {'key': 'value'};
      when(
        () => analytics.logEvent(
          name: eventName,
          parameters: parameters,
        ),
      ).thenAnswer((_) async {});
      when(
        () => trackable.trackEvent(
          eventName,
          parameters: parameters,
        ),
      ).thenAnswer((_) async {});

      await tracker.logEvent(eventName, parameters: parameters);

      verify(
        () => analytics.logEvent(
          name: eventName,
          parameters: parameters,
        ),
      ).called(1);
      verify(
        () => trackable.trackEvent(
          eventName,
          parameters: parameters,
        ),
      ).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });
  });
}
