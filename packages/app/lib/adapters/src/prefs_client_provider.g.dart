// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'prefs_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prefsClientHash() => r'5f518da0dbf69a64961b70ca08b759d59d98cf09';

/// Provider for the shared preferences client.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.
///
/// Copied from [prefsClient].
@ProviderFor(prefsClient)
final prefsClientProvider = Provider<PrefsClient>.internal(
  prefsClient,
  name: r'prefsClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prefsClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PrefsClientRef = ProviderRef<PrefsClient>;
String _$textInputHapticEnabledHash() =>
    r'fc559251adce43491fd984dbfaceca7c85e6f745';

/// Provider for text input haptic feedback enabled state.
///
/// This provider manages the text input haptic feedback setting,
/// providing reactive updates when the preference changes.
///
/// Copied from [TextInputHapticEnabled].
@ProviderFor(TextInputHapticEnabled)
final textInputHapticEnabledProvider =
    AutoDisposeNotifierProvider<TextInputHapticEnabled, bool>.internal(
      TextInputHapticEnabled.new,
      name: r'textInputHapticEnabledProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$textInputHapticEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TextInputHapticEnabled = AutoDisposeNotifier<bool>;
String _$otherHapticEnabledHash() =>
    r'361a3a32267621eaf08262a99b5df7d63c39bd1e';

/// Provider for other haptic feedback enabled state.
///
/// This provider manages the other haptic feedback setting (button taps,
/// toggles, navigation), providing reactive updates when the preference
/// changes.
///
/// Copied from [OtherHapticEnabled].
@ProviderFor(OtherHapticEnabled)
final otherHapticEnabledProvider =
    AutoDisposeNotifierProvider<OtherHapticEnabled, bool>.internal(
      OtherHapticEnabled.new,
      name: r'otherHapticEnabledProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$otherHapticEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OtherHapticEnabled = AutoDisposeNotifier<bool>;
String _$notificationSettingsHash() =>
    r'5f87bb0bc7e58b63f567698d8ca924fd0d4665dc';

/// {@template onepage.NotificationSettingsNotifier}
/// Notifier for managing notification settings.
/// {@endtemplate}
///
/// Copied from [NotificationSettings].
@ProviderFor(NotificationSettings)
final notificationSettingsProvider =
    AutoDisposeNotifierProvider<
      NotificationSettings,
      List<NotificationSetting>
    >.internal(
      NotificationSettings.new,
      name: r'notificationSettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationSettings = AutoDisposeNotifier<List<NotificationSetting>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
