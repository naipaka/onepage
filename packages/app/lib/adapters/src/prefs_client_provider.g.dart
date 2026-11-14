// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'prefs_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Initializes the shared preferences client once at startup.

@ProviderFor(prefsClientInitializing)
final prefsClientInitializingProvider = PrefsClientInitializingProvider._();

/// Initializes the shared preferences client once at startup.

final class PrefsClientInitializingProvider
    extends
        $FunctionalProvider<
          AsyncValue<PrefsClient>,
          PrefsClient,
          FutureOr<PrefsClient>
        >
    with $FutureModifier<PrefsClient>, $FutureProvider<PrefsClient> {
  /// Initializes the shared preferences client once at startup.
  PrefsClientInitializingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefsClientInitializingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefsClientInitializingHash();

  @$internal
  @override
  $FutureProviderElement<PrefsClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PrefsClient> create(Ref ref) {
    return prefsClientInitializing(ref);
  }
}

String _$prefsClientInitializingHash() =>
    r'62febdb5e5ee7ebeddc03cfd6222f84cc7670355';

/// Provider for the shared preferences client.
///
/// After initialization, use this, which can be obtained synchronously.

@ProviderFor(prefsClient)
final prefsClientProvider = PrefsClientProvider._();

/// Provider for the shared preferences client.
///
/// After initialization, use this, which can be obtained synchronously.

final class PrefsClientProvider
    extends $FunctionalProvider<PrefsClient, PrefsClient, PrefsClient>
    with $Provider<PrefsClient> {
  /// Provider for the shared preferences client.
  ///
  /// After initialization, use this, which can be obtained synchronously.
  PrefsClientProvider._()
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

String _$prefsClientHash() => r'51d8c22763c005e56589fdce611f468d09599032';

/// Provider for text input haptic feedback enabled state.
///
/// This provider manages the text input haptic feedback setting,
/// providing reactive updates when the preference changes.

@ProviderFor(TextInputHapticEnabled)
final textInputHapticEnabledProvider = TextInputHapticEnabledProvider._();

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
  TextInputHapticEnabledProvider._()
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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider for other haptic feedback enabled state.
///
/// This provider manages the other haptic feedback setting (button taps,
/// toggles, navigation), providing reactive updates when the preference
/// changes.

@ProviderFor(OtherHapticEnabled)
final otherHapticEnabledProvider = OtherHapticEnabledProvider._();

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
  OtherHapticEnabledProvider._()
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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider for whether the user declined to recover the remaining photos.

@ProviderFor(PhotoRecoveryDismissed)
final photoRecoveryDismissedProvider = PhotoRecoveryDismissedProvider._();

/// Provider for whether the user declined to recover the remaining photos.
final class PhotoRecoveryDismissedProvider
    extends $NotifierProvider<PhotoRecoveryDismissed, bool> {
  /// Provider for whether the user declined to recover the remaining photos.
  PhotoRecoveryDismissedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoRecoveryDismissedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoRecoveryDismissedHash();

  @$internal
  @override
  PhotoRecoveryDismissed create() => PhotoRecoveryDismissed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$photoRecoveryDismissedHash() =>
    r'8d3f1788c56c94d2e46ebe959e3322c2b7331135';

/// Provider for whether the user declined to recover the remaining photos.

abstract class _$PhotoRecoveryDismissed extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// {@template onepage.NotificationSettingsNotifier}
/// Notifier for managing notification settings.
/// {@endtemplate}

@ProviderFor(NotificationSettings)
final notificationSettingsProvider = NotificationSettingsProvider._();

/// {@template onepage.NotificationSettingsNotifier}
/// Notifier for managing notification settings.
/// {@endtemplate}
final class NotificationSettingsProvider
    extends $NotifierProvider<NotificationSettings, List<NotificationSetting>> {
  /// {@template onepage.NotificationSettingsNotifier}
  /// Notifier for managing notification settings.
  /// {@endtemplate}
  NotificationSettingsProvider._()
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
  WhenComplete runBuild() {
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
    return element.handleCreate(ref, build);
  }
}
