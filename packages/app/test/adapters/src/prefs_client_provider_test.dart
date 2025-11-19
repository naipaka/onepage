import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notification_client/notification_client.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:prefs_client/prefs_client.dart';

import 'prefs_client_provider_test.mocks.dart';

@GenerateMocks([PrefsClient])
void main() {
  group('PrefsClientProvider', () {
    late ProviderContainer container;
    late MockPrefsClient mockPrefsClient;

    setUp(() {
      mockPrefsClient = MockPrefsClient();
      when(mockPrefsClient.textInputHapticEnabled).thenReturn(true);
      when(mockPrefsClient.otherHapticEnabled).thenReturn(false);
      when(mockPrefsClient.notificationSettings).thenReturn([]);
      when(
        mockPrefsClient.setTextInputHapticEnabled(enabled: anyNamed('enabled')),
      ).thenAnswer((_) async => true);
      when(
        mockPrefsClient.setOtherHapticEnabled(enabled: anyNamed('enabled')),
      ).thenAnswer((_) async => true);
      when(
        mockPrefsClient.setNotificationSettings(any),
      ).thenAnswer((_) async => true);

      container = ProviderContainer(
        overrides: [
          prefsClientProvider.overrideWithValue(mockPrefsClient),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('prefsClientProvider throws UnimplementedError by default', () {
      final container = ProviderContainer();
      expect(
        () => container.read(prefsClientProvider),
        throwsA(
          predicate(
            (e) =>
                e.toString().contains('UnimplementedError') ||
                (e is Error && e.toString().contains('UnimplementedError')),
          ),
        ),
      );
      container.dispose();
    });

    test('textInputHapticEnabledProvider returns initial state', () {
      final isEnabled = container.read(textInputHapticEnabledProvider);
      expect(isEnabled, isTrue);
      verify(mockPrefsClient.textInputHapticEnabled);
    });

    test('textInputHapticEnabledProvider can update state', () async {
      final notifier = container.read(textInputHapticEnabledProvider.notifier);

      await notifier.setEnabled(enabled: false);

      expect(container.read(textInputHapticEnabledProvider), isFalse);
      verify(mockPrefsClient.setTextInputHapticEnabled(enabled: false));
    });

    test('otherHapticEnabledProvider returns initial state', () {
      final isEnabled = container.read(otherHapticEnabledProvider);
      expect(isEnabled, isFalse);
      verify(mockPrefsClient.otherHapticEnabled);
    });

    test('otherHapticEnabledProvider can update state', () async {
      final notifier = container.read(otherHapticEnabledProvider.notifier);

      await notifier.setEnabled(enabled: true);

      expect(container.read(otherHapticEnabledProvider), isTrue);
      verify(mockPrefsClient.setOtherHapticEnabled(enabled: true));
    });

    test(
      'notificationSettingsProvider returns default settings when empty',
      () {
        final settings = container.read(notificationSettingsProvider);

        expect(settings.length, equals(3));
        expect(settings.every((s) => !s.isEnabled), isTrue);
        expect(settings.map((s) => s.hour), containsAll([8, 12, 20]));
      },
    );

    test('notificationSettingsProvider can add notification time', () async {
      final notifier = container.read(notificationSettingsProvider.notifier);

      final initialSettings = [
        const NotificationSetting(id: 1, hour: 8, isEnabled: false),
        const NotificationSetting(id: 2, hour: 12, isEnabled: false),
      ];

      when(mockPrefsClient.notificationSettings).thenReturn(
        initialSettings.map((s) => s.toJson()).toList(),
      );

      container.refresh(notificationSettingsProvider);

      await notifier.addNotificationTime(18);

      final settings = container.read(notificationSettingsProvider);
      expect(settings.length, equals(3));
      expect(settings.last.hour, equals(18));
    });

    test('notificationSettingsProvider can toggle notification', () async {
      final notifier = container.read(notificationSettingsProvider.notifier);

      await notifier.toggleNotification(1);

      verify(mockPrefsClient.setNotificationSettings(any));
    });
  });
}
