import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_client/notification_client.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prefs_client_provider.g.dart';

/// Provider for the shared preferences client.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.
@Riverpod(keepAlive: true)
PrefsClient prefsClient(Ref ref) {
  throw UnimplementedError(
    'PrefsClient provider must be overridden with an initialized instance '
    'in main.dart',
  );
}

/// Provider for text input haptic feedback enabled state.
///
/// This provider manages the text input haptic feedback setting,
/// providing reactive updates when the preference changes.
@riverpod
class TextInputHapticEnabled extends _$TextInputHapticEnabled {
  @override
  bool build() {
    final prefsClient = ref.watch(prefsClientProvider);
    return prefsClient.textInputHapticEnabled;
  }

  /// Updates the text input haptic feedback enabled state.
  ///
  /// This method updates both the provider state and persists the change
  /// to SharedPreferences.
  Future<void> setEnabled({required bool enabled}) async {
    state = enabled;
    final prefsClient = ref.read(prefsClientProvider);
    await prefsClient.setTextInputHapticEnabled(enabled: enabled);
  }
}

/// Provider for other haptic feedback enabled state.
///
/// This provider manages the other haptic feedback setting (button taps,
/// toggles, navigation), providing reactive updates when the preference
/// changes.
@riverpod
class OtherHapticEnabled extends _$OtherHapticEnabled {
  @override
  bool build() {
    final prefsClient = ref.watch(prefsClientProvider);
    return prefsClient.otherHapticEnabled;
  }

  /// Updates the other haptic feedback enabled state.
  ///
  /// This method updates both the provider state and persists the change
  /// to SharedPreferences.
  Future<void> setEnabled({required bool enabled}) async {
    state = enabled;
    final prefsClient = ref.read(prefsClientProvider);
    await prefsClient.setOtherHapticEnabled(enabled: enabled);
  }
}

/// {@template onepage.NotificationSettingsNotifier}
/// Notifier for managing notification settings.
/// {@endtemplate}
@riverpod
class NotificationSettings extends _$NotificationSettings {
  @override
  List<NotificationSetting> build() {
    final prefsClient = ref.watch(prefsClientProvider);
    final jsonList = prefsClient.notificationSettings;
    final settings = jsonList.map(NotificationSetting.fromJson).toList();

    // If no settings exist, create default settings
    if (settings.isEmpty) {
      const defaultSettings = [
        NotificationSetting(id: 1, hour: 8, isEnabled: false),
        NotificationSetting(id: 2, hour: 12, isEnabled: false),
        NotificationSetting(id: 3, hour: 20, isEnabled: false),
      ];
      return defaultSettings;
    }

    return settings;
  }

  /// Add a new notification time.
  Future<void> addNotificationTime(int hour) async {
    final currentSettings = state;

    // Prevent adding more than 3 notifications
    if (currentSettings.length >= 3) {
      return;
    }

    // Generate new ID
    final newId = currentSettings.isEmpty
        ? 1
        : currentSettings.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;

    final newSetting = NotificationSetting(
      id: newId,
      hour: hour,
      isEnabled: false,
    );

    final updatedSettings = [...currentSettings, newSetting];
    await _saveSettings(updatedSettings);
    state = updatedSettings;
  }

  /// Update an existing notification time.
  Future<void> updateNotificationTime(int id, int hour) async {
    final currentSettings = state;
    final updatedSettings = currentSettings.map((setting) {
      if (setting.id == id) {
        return setting.copyWith(hour: hour);
      }
      return setting;
    }).toList();
    await _saveSettings(updatedSettings);
    state = updatedSettings;
  }

  /// Remove a notification setting.
  Future<void> removeNotificationTime(int id) async {
    final currentSettings = state;

    // Prevent removing the last setting
    if (currentSettings.length <= 1) {
      return;
    }

    final updatedSettings = currentSettings.where((s) => s.id != id).toList();
    await _saveSettings(updatedSettings);
    state = updatedSettings;
  }

  /// Toggle notification enabled/disabled.
  Future<void> toggleNotification(int id) async {
    final currentSettings = state;

    final updatedSettings = currentSettings.map((setting) {
      if (setting.id == id) {
        return setting.copyWith(isEnabled: !setting.isEnabled);
      }
      return setting;
    }).toList();

    await _saveSettings(updatedSettings);
    state = updatedSettings;
  }

  /// Save settings to preferences.
  Future<void> _saveSettings(List<NotificationSetting> settings) async {
    final prefsClient = ref.read(prefsClientProvider);
    final jsonList = settings.map((setting) => setting.toJson()).toList();
    await prefsClient.setNotificationSettings(jsonList);
  }
}
