// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'prefs_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the shared preferences client.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.

@ProviderFor(prefsClient)
const prefsClientProvider = PrefsClientProvider._();

/// Provider for the shared preferences client.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.

final class PrefsClientProvider
    extends $FunctionalProvider<PrefsClient, PrefsClient, PrefsClient>
    with $Provider<PrefsClient> {
  /// Provider for the shared preferences client.
  ///
  /// This provider must be overridden in main.dart with an initialized instance.
  /// By default, it throws UnimplementedError to ensure proper initialization.
  const PrefsClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefsClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefsClientHash();

  @$internal
  @override
  $ProviderElement<PrefsClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrefsClient create(Ref ref) {
    return prefsClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrefsClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrefsClient>(value),
    );
  }
}

String _$prefsClientHash() => r'5f518da0dbf69a64961b70ca08b759d59d98cf09';

/// Provider for text input haptic feedback enabled state.
///
/// This provider manages the text input haptic feedback setting,
/// providing reactive updates when the preference changes.

@ProviderFor(TextInputHapticEnabled)
const textInputHapticEnabledProvider = TextInputHapticEnabledProvider._();

/// Provider for text input haptic feedback enabled state.
///
/// This provider manages the text input haptic feedback setting,
/// providing reactive updates when the preference changes.
final class TextInputHapticEnabledProvider
    extends $NotifierProvider<TextInputHapticEnabled, bool> {
  /// Provider for text input haptic feedback enabled state.
  ///
  /// This provider manages the text input haptic feedback setting,
  /// providing reactive updates when the preference changes.
  const TextInputHapticEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'textInputHapticEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$textInputHapticEnabledHash();

  @$internal
  @override
  TextInputHapticEnabled create() => TextInputHapticEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$textInputHapticEnabledHash() =>
    r'fc559251adce43491fd984dbfaceca7c85e6f745';

/// Provider for text input haptic feedback enabled state.
///
/// This provider manages the text input haptic feedback setting,
/// providing reactive updates when the preference changes.

abstract class _$TextInputHapticEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for other haptic feedback enabled state.
///
/// This provider manages the other haptic feedback setting (button taps,
/// toggles, navigation), providing reactive updates when the preference
/// changes.

@ProviderFor(OtherHapticEnabled)
const otherHapticEnabledProvider = OtherHapticEnabledProvider._();

/// Provider for other haptic feedback enabled state.
///
/// This provider manages the other haptic feedback setting (button taps,
/// toggles, navigation), providing reactive updates when the preference
/// changes.
final class OtherHapticEnabledProvider
    extends $NotifierProvider<OtherHapticEnabled, bool> {
  /// Provider for other haptic feedback enabled state.
  ///
  /// This provider manages the other haptic feedback setting (button taps,
  /// toggles, navigation), providing reactive updates when the preference
  /// changes.
  const OtherHapticEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otherHapticEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otherHapticEnabledHash();

  @$internal
  @override
  OtherHapticEnabled create() => OtherHapticEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$otherHapticEnabledHash() =>
    r'361a3a32267621eaf08262a99b5df7d63c39bd1e';

/// Provider for other haptic feedback enabled state.
///
/// This provider manages the other haptic feedback setting (button taps,
/// toggles, navigation), providing reactive updates when the preference
/// changes.

abstract class _$OtherHapticEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// {@template onepage.NotificationSettingsNotifier}
/// Notifier for managing notification settings.
/// {@endtemplate}

@ProviderFor(NotificationSettings)
const notificationSettingsProvider = NotificationSettingsProvider._();

/// {@template onepage.NotificationSettingsNotifier}
/// Notifier for managing notification settings.
/// {@endtemplate}
final class NotificationSettingsProvider
    extends $NotifierProvider<NotificationSettings, List<NotificationSetting>> {
  /// {@template onepage.NotificationSettingsNotifier}
  /// Notifier for managing notification settings.
  /// {@endtemplate}
  const NotificationSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsHash();

  @$internal
  @override
  NotificationSettings create() => NotificationSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NotificationSetting> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NotificationSetting>>(value),
    );
  }
}

String _$notificationSettingsHash() =>
    r'1c106e81a576dcf1c62c1076b02b25df4dcb5ffb';

/// {@template onepage.NotificationSettingsNotifier}
/// Notifier for managing notification settings.
/// {@endtemplate}

abstract class _$NotificationSettings
    extends $Notifier<List<NotificationSetting>> {
  List<NotificationSetting> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<NotificationSetting>, List<NotificationSetting>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<NotificationSetting>, List<NotificationSetting>>,
              List<NotificationSetting>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
