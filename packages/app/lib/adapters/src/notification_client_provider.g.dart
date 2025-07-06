// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'notification_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationClientInitializingHash() =>
    r'd64dbc648bd8cbe4986a4f985ab9ccc763868544';

/// Initialize the [NotificationClient] and set up notification system.
///
/// Copied from [notificationClientInitializing].
@ProviderFor(notificationClientInitializing)
final notificationClientInitializingProvider =
    FutureProvider<NotificationClient>.internal(
      notificationClientInitializing,
      name: r'notificationClientInitializingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationClientInitializingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationClientInitializingRef =
    FutureProviderRef<NotificationClient>;
String _$notificationClientHash() =>
    r'da59d538feacde7c34dadbe5fdd5aa4a7a24187b';

/// {@template onepage.notificationClientProvider}
/// Provider for NotificationClient instance.
/// {@endtemplate}
///
/// Copied from [notificationClient].
@ProviderFor(notificationClient)
final notificationClientProvider = Provider<NotificationClient>.internal(
  notificationClient,
  name: r'notificationClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationClientRef = ProviderRef<NotificationClient>;
String _$notificationPermissionGrantedHash() =>
    r'6706175c0d09d35ffb1753894e4b153a14375585';

/// {@template notificationPermissionGrantedProvider}
/// Provider for notification permission granted status.
/// {@endtemplate}
///
/// Copied from [notificationPermissionGranted].
@ProviderFor(notificationPermissionGranted)
final notificationPermissionGrantedProvider =
    AutoDisposeFutureProvider<bool>.internal(
      notificationPermissionGranted,
      name: r'notificationPermissionGrantedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationPermissionGrantedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationPermissionGrantedRef = AutoDisposeFutureProviderRef<bool>;
String _$notificationSchedulerHash() =>
    r'30ec68bda05e15c5d388abc0fbbbcac2e91d6793';

/// {@template onepage.NotificationScheduler}
/// Notifier that manages notification scheduling based on settings changes.
/// This notifier automatically schedules/reschedules notifications when
/// settings, diary entries, or skip preferences change.
/// {@endtemplate}
///
/// Copied from [NotificationScheduler].
@ProviderFor(NotificationScheduler)
final notificationSchedulerProvider =
    NotifierProvider<NotificationScheduler, void>.internal(
      NotificationScheduler.new,
      name: r'notificationSchedulerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationSchedulerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationScheduler = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
