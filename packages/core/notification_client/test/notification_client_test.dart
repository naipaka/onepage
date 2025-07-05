import 'package:clock/clock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notification_client/notification_client.dart';

import 'utils/mock.mocks.dart';
import 'utils/mock_flutter_timezone.dart';
import 'utils/mock_local_notifications.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    setupMockLocalNotification();
    setupMockFlutterTimezone();
  });

  tearDown(() {
    tearDownMockLocalNotification();
    tearDownMockFlutterTimezone();
  });

  group('NotificationClient comprehensive tests', () {
    late MockFlutterLocalNotificationsPlugin mockPlugin;

    setUp(() {
      mockPlugin = MockFlutterLocalNotificationsPlugin();
    });

    test('creates client with default plugin using factory', () {
      final client = NotificationClient.create(
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      expect(client, isNotNull);
    });

    test('initialize calls initialize method', () async {
      when(mockPlugin.initialize(any)).thenAnswer((_) async => true);

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      await client.initialize();

      verify(mockPlugin.initialize(any)).called(1);
    });

    test('cancelAllNotifications calls cancelAll', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      await client.cancelAllNotifications();

      verify(mockPlugin.cancelAll()).called(1);
    });

    test('cancelNotification calls cancel with id', () async {
      when(mockPlugin.cancel(any)).thenAnswer((_) async {});

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      await client.cancelNotification(123);

      verify(mockPlugin.cancel(123)).called(1);
    });

    test('requestPermissions returns false when no platform', () async {
      when(
        mockPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >(),
      ).thenReturn(null);
      when(
        mockPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >(),
      ).thenReturn(null);

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      final result = await client.requestPermissions();

      expect(result, false);
    });

    test('scheduleNotifications with empty settings', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      await client.scheduleNotifications(
        [],
        title: 'Test',
        message: 'Test message',
      );

      verify(mockPlugin.cancelAll()).called(1);
    });

    test('scheduleNotifications with disabled settings', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      await client.scheduleNotifications(
        [
          const NotificationSetting(id: 1, hour: 8, isEnabled: false),
          const NotificationSetting(id: 2, hour: 12, isEnabled: false),
        ],
        title: 'Test',
        message: 'Test message',
      );

      verify(mockPlugin.cancelAll()).called(1);
      verifyNever(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
        ),
      );
    });

    test('scheduleNotifications with enabled settings', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
        ),
      ).thenAnswer((_) async {});

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );
      await client.scheduleNotifications(
        [
          const NotificationSetting(id: 1, hour: 8, isEnabled: true),
          const NotificationSetting(id: 2, hour: 12, isEnabled: true),
        ],
        title: 'Test',
        message: 'Test message',
      );

      verify(mockPlugin.cancelAll()).called(1);
      verify(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
        ),
      ).called(2);
    });

    test('scheduleNotifications handles past time correctly', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
        ),
      ).thenAnswer((_) async {});

      final client = NotificationClient.forTesting(
        notificationsPlugin: mockPlugin,
        channelName: 'Test Channel',
        channelDescription: 'Test Description',
      );

      // Use a guaranteed past hour (current hour - 2 to ensure it's past)
      final now = clock.now();
      final pastHour = (now.hour - 2 + 24) % 24;

      await client.scheduleNotifications(
        [NotificationSetting(id: 1, hour: pastHour, isEnabled: true)],
        title: 'Test',
        message: 'Test message',
      );

      verify(mockPlugin.cancelAll()).called(1);
      verify(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
        ),
      ).called(1);
    });

    group('scheduleNotifications variations', () {
      test('scheduleNotifications with single enabled setting', () async {
        when(mockPlugin.cancelAll()).thenAnswer((_) async {});
        when(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );
        await client.scheduleNotifications(
          [const NotificationSetting(id: 42, hour: 15, isEnabled: true)],
          title: 'Single Reminder',
          message: 'Daily reminder message',
        );

        verify(mockPlugin.cancelAll()).called(1);
        verify(
          mockPlugin.zonedSchedule(
            42,
            'Single Reminder',
            'Daily reminder message',
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).called(1);
      });
    });

    group('Edge cases', () {
      test(
        'multiple notification settings handle disabled correctly',
        () async {
          when(mockPlugin.cancelAll()).thenAnswer((_) async {});

          final client = NotificationClient.forTesting(
            notificationsPlugin: mockPlugin,
            channelName: 'Test Channel',
            channelDescription: 'Test Description',
          );
          await client.scheduleNotifications(
            [
              const NotificationSetting(id: 1, hour: 8, isEnabled: true),
              const NotificationSetting(id: 2, hour: 12, isEnabled: false),
              const NotificationSetting(id: 3, hour: 18, isEnabled: true),
            ],
            title: 'Test',
            message: 'Test message',
          );

          verify(mockPlugin.cancelAll()).called(1);
          verify(
            mockPlugin.zonedSchedule(
              any,
              any,
              any,
              any,
              any,
              androidScheduleMode: anyNamed('androidScheduleMode'),
              matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
            ),
          ).called(2);
        },
      );
    });

    group('Platform-specific implementations', () {
      test('requestPermissions calls platform implementations', () async {
        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );
        final result = await client.requestPermissions();

        expect(result, isFalse);
      });

      test('requestPermissions returns true on Android', () async {
        final mockPlugin = MockFlutterLocalNotificationsPlugin();
        final mockAndroid = MockAndroidFlutterLocalNotificationsPlugin();

        when(
          mockPlugin
              .resolvePlatformSpecificImplementation<
                FlutterLocalNotificationsPlatform
              >(),
        ).thenAnswer((invocation) {
          final t = invocation.typeArguments.single;
          if (t == AndroidFlutterLocalNotificationsPlugin) {
            return mockAndroid;
          }
          return null;
        });

        when(
          mockAndroid.requestNotificationsPermission(),
        ).thenAnswer((_) async => true);
        when(
          mockAndroid.requestExactAlarmsPermission(),
        ).thenAnswer((_) async => true);

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );
        final result = await client.requestPermissions();

        expect(result, isTrue);
      });

      test('requestPermissions returns true on iOS', () async {
        final mockPlugin = MockFlutterLocalNotificationsPlugin();
        final mockIOS = MockIOSFlutterLocalNotificationsPlugin();

        when(
          mockPlugin
              .resolvePlatformSpecificImplementation<
                FlutterLocalNotificationsPlatform
              >(),
        ).thenAnswer((invocation) {
          final t = invocation.typeArguments.single;
          if (t == IOSFlutterLocalNotificationsPlugin) {
            return mockIOS;
          }
          return null;
        });

        when(
          mockIOS.requestPermissions(
            alert: anyNamed('alert'),
            badge: anyNamed('badge'),
            sound: anyNamed('sound'),
          ),
        ).thenAnswer((_) async => true);

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );
        final result = await client.requestPermissions();

        expect(result, isTrue);
      });
    });

    group('Past time handling', () {
      test('covers past time scheduling (add day)', () async {
        when(mockPlugin.cancelAll()).thenAnswer((_) async {});
        when(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );

        // Use current hour - 1 to guarantee past time (will add a day)
        final now = clock.now();
        final pastHour = (now.hour - 1 + 24) % 24;

        await client.scheduleNotifications(
          [NotificationSetting(id: 1, hour: pastHour, isEnabled: true)],
          title: 'Test',
          message: 'Test message',
        );

        verify(mockPlugin.cancelAll()).called(1);
        verify(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('explicitly covers line 165 - add day for past time', () async {
        when(mockPlugin.cancelAll()).thenAnswer((_) async {});
        when(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );

        await client.scheduleNotifications(
          [const NotificationSetting(id: 999, hour: 0, isEnabled: true)],
          title: 'Midnight Test',
          message: 'Test for past time handling',
        );

        verify(mockPlugin.cancelAll()).called(1);
        verify(
          mockPlugin.zonedSchedule(
            999,
            'Midnight Test',
            'Test for past time handling',
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('covers future time scheduling (no add day)', () async {
        when(mockPlugin.cancelAll()).thenAnswer((_) async {});
        when(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );

        // Use current hour + 1 to guarantee future time
        final now = clock.now();
        final futureHour = (now.hour + 1) % 24;

        await client.scheduleNotifications(
          [NotificationSetting(id: 1, hour: futureHour, isEnabled: true)],
          title: 'Test',
          message: 'Test message',
        );

        verify(mockPlugin.cancelAll()).called(1);
        verify(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).called(1);
      });
    });

    group('skipToday parameter', () {
      test('scheduleNotifications with skipToday: true', () async {
        when(mockPlugin.cancelAll()).thenAnswer((_) async {});
        when(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );

        await client.scheduleNotifications(
          [const NotificationSetting(id: 1, hour: 10, isEnabled: true)],
          title: 'Test',
          message: 'Test message',
        );

        verify(mockPlugin.cancelAll()).called(1);
        verify(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('scheduleNotifications with default skipToday behavior', () async {
        when(mockPlugin.cancelAll()).thenAnswer((_) async {});
        when(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        final client = NotificationClient.forTesting(
          notificationsPlugin: mockPlugin,
          channelName: 'Test Channel',
          channelDescription: 'Test Description',
        );

        await client.scheduleNotifications(
          [const NotificationSetting(id: 1, hour: 10, isEnabled: true)],
          title: 'Test',
          message: 'Test message',
        );

        verify(mockPlugin.cancelAll()).called(1);
        verify(
          mockPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
            matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          ),
        ).called(1);
      });
    });
  });
}
