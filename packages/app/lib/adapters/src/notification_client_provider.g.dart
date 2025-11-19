// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'notification_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Initialize the [NotificationClient] and set up notification system.

@ProviderFor(notificationClientInitializing)
const notificationClientInitializingProvider =
    NotificationClientInitializingProvider._();

/// Initialize the [NotificationClient] and set up notification system.

final class NotificationClientInitializingProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationClient>,
          NotificationClient,
          FutureOr<NotificationClient>
        >
    with
        $FutureModifier<NotificationClient>,
        $FutureProvider<NotificationClient> {
  /// Initialize the [NotificationClient] and set up notification system.
  const NotificationClientInitializingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationClientInitializingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationClientInitializingHash();

  @$internal
  @override
  $FutureProviderElement<NotificationClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificationClient> create(Ref ref) {
    return notificationClientInitializing(ref);
  }
}

String _$notificationClientInitializingHash() =>
    r'd64dbc648bd8cbe4986a4f985ab9ccc763868544';

/// {@template onepage.notificationClientProvider}
/// Provider for NotificationClient instance.
/// {@endtemplate}

@ProviderFor(notificationClient)
const notificationClientProvider = NotificationClientProvider._();

/// {@template onepage.notificationClientProvider}
/// Provider for NotificationClient instance.
/// {@endtemplate}

final class NotificationClientProvider
    extends
        $FunctionalProvider<
          NotificationClient,
          NotificationClient,
          NotificationClient
        >
    with $Provider<NotificationClient> {
  /// {@template onepage.notificationClientProvider}
  /// Provider for NotificationClient instance.
  /// {@endtemplate}
  const NotificationClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationClientHash();

  @$internal
  @override
  $ProviderElement<NotificationClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationClient create(Ref ref) {
    return notificationClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationClient>(value),
    );
  }
}

String _$notificationClientHash() =>
    r'da59d538feacde7c34dadbe5fdd5aa4a7a24187b';

/// {@template notificationPermissionGrantedProvider}
/// Provider for notification permission granted status.
/// {@endtemplate}

@ProviderFor(notificationPermissionGranted)
const notificationPermissionGrantedProvider =
    NotificationPermissionGrantedProvider._();

/// {@template notificationPermissionGrantedProvider}
/// Provider for notification permission granted status.
/// {@endtemplate}

final class NotificationPermissionGrantedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// {@template notificationPermissionGrantedProvider}
  /// Provider for notification permission granted status.
  /// {@endtemplate}
  const NotificationPermissionGrantedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionGrantedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionGrantedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return notificationPermissionGranted(ref);
  }
}

String _$notificationPermissionGrantedHash() =>
    r'6706175c0d09d35ffb1753894e4b153a14375585';

/// {@template onepage.NotificationScheduler}
/// Notifier that manages notification scheduling based on settings changes.
/// This notifier automatically schedules/reschedules notifications when
/// settings, diary entries, or skip preferences change.
/// {@endtemplate}

@ProviderFor(NotificationScheduler)
const notificationSchedulerProvider = NotificationSchedulerProvider._();

/// {@template onepage.NotificationScheduler}
/// Notifier that manages notification scheduling based on settings changes.
/// This notifier automatically schedules/reschedules notifications when
/// settings, diary entries, or skip preferences change.
/// {@endtemplate}
final class NotificationSchedulerProvider
    extends $NotifierProvider<NotificationScheduler, void> {
  /// {@template onepage.NotificationScheduler}
  /// Notifier that manages notification scheduling based on settings changes.
  /// This notifier automatically schedules/reschedules notifications when
  /// settings, diary entries, or skip preferences change.
  /// {@endtemplate}
  const NotificationSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSchedulerHash();

  @$internal
  @override
  NotificationScheduler create() => NotificationScheduler();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$notificationSchedulerHash() =>
    r'30ec68bda05e15c5d388abc0fbbbcac2e91d6793';

/// {@template onepage.NotificationScheduler}
/// Notifier that manages notification scheduling based on settings changes.
/// This notifier automatically schedules/reschedules notifications when
/// settings, diary entries, or skip preferences change.
/// {@endtemplate}

abstract class _$NotificationScheduler extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
