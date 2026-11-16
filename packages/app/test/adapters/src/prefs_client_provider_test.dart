import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_client/notification_client.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:prefs_client/prefs_client.dart';

import '../../utils/clients.dart';

void main() {
  group('PrefsClientProvider', () {
    late PrefsClient prefsClient;
    late ProviderContainer container;

    Future<void> setUpPrefs(Map<String, Object> values) async {
      prefsClient = await createPrefsClient(values);
      container = ProviderContainer(
        overrides: [prefsClientProvider.overrideWithValue(prefsClient)],
      );
      addTearDown(container.dispose);
    }

    setUp(
      () => setUpPrefs({'textInputHaptic': true, 'otherHaptic': false}),
    );

    test('prefsClientProvider is not available before initialization', () {
      final container = ProviderContainer(
        overrides: [
          prefsClientInitializingProvider.overrideWith(
            (ref) => Completer<PrefsClient>().future,
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(() => container.read(prefsClientProvider), throwsA(anything));
    });

    test('prefsClientProvider provides the initialized client', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final client = await container.read(
        prefsClientInitializingProvider.future,
      );

      expect(container.read(prefsClientProvider), client);
    });

    test('textInputHapticEnabledProvider returns the stored value', () {
      expect(container.read(textInputHapticEnabledProvider), isTrue);
    });

    test('textInputHapticEnabledProvider stores a new value', () async {
      final notifier = container.read(textInputHapticEnabledProvider.notifier);

      await notifier.setEnabled(enabled: false);

      expect(container.read(textInputHapticEnabledProvider), isFalse);
      expect(prefsClient.textInputHapticEnabled, isFalse);
    });

    test('otherHapticEnabledProvider returns the stored value', () {
      expect(container.read(otherHapticEnabledProvider), isFalse);
    });

    test('otherHapticEnabledProvider stores a new value', () async {
      final notifier = container.read(otherHapticEnabledProvider.notifier);

      await notifier.setEnabled(enabled: true);

      expect(container.read(otherHapticEnabledProvider), isTrue);
      expect(prefsClient.otherHapticEnabled, isTrue);
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
      await prefsClient.setNotificationSettings([
        const NotificationSetting(id: 1, hour: 8, isEnabled: false).toJson(),
        const NotificationSetting(id: 2, hour: 12, isEnabled: false).toJson(),
      ]);
      final notifier = container.read(notificationSettingsProvider.notifier);

      await notifier.addNotificationTime(18);

      final settings = container.read(notificationSettingsProvider);
      expect(settings.map((s) => s.hour), [8, 12, 18]);
      expect(
        prefsClient.notificationSettings.map(NotificationSetting.fromJson),
        settings,
      );
    });

    test('notificationSettingsProvider can toggle notification', () async {
      final notifier = container.read(notificationSettingsProvider.notifier);

      await notifier.toggleNotification(1);

      final stored = prefsClient.notificationSettings
          .map(NotificationSetting.fromJson)
          .toList();
      expect(stored.firstWhere((s) => s.id == 1).isEnabled, isTrue);
    });
  });
}
