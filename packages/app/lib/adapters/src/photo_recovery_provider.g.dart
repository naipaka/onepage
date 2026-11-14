// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'photo_recovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the photos saved on the device.

@ProviderFor(devicePhotos)
final devicePhotosProvider = DevicePhotosProvider._();

/// Provides the photos saved on the device.

final class DevicePhotosProvider
    extends $FunctionalProvider<DevicePhotos, DevicePhotos, DevicePhotos>
    with $Provider<DevicePhotos> {
  /// Provides the photos saved on the device.
  DevicePhotosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devicePhotosProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devicePhotosHash();

  @$internal
  @override
  $ProviderElement<DevicePhotos> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DevicePhotos create(Ref ref) {
    return devicePhotos(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevicePhotos value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevicePhotos>(value),
    );
  }
}

String _$devicePhotosHash() => r'c624d0ac9fa85cceeeaf64f1b4a7ede8eeae209e';

/// A provider that creates a [PhotoRecoveryCommand] instance.
///
/// {@macro photo_recovery.PhotoRecoveryCommand}

@ProviderFor(photoRecoveryCommand)
final photoRecoveryCommandProvider = PhotoRecoveryCommandProvider._();

/// A provider that creates a [PhotoRecoveryCommand] instance.
///
/// {@macro photo_recovery.PhotoRecoveryCommand}

final class PhotoRecoveryCommandProvider
    extends
        $FunctionalProvider<
          PhotoRecoveryCommand,
          PhotoRecoveryCommand,
          PhotoRecoveryCommand
        >
    with $Provider<PhotoRecoveryCommand> {
  /// A provider that creates a [PhotoRecoveryCommand] instance.
  ///
  /// {@macro photo_recovery.PhotoRecoveryCommand}
  PhotoRecoveryCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoRecoveryCommandProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoRecoveryCommandHash();

  @$internal
  @override
  $ProviderElement<PhotoRecoveryCommand> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PhotoRecoveryCommand create(Ref ref) {
    return photoRecoveryCommand(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoRecoveryCommand value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoRecoveryCommand>(value),
    );
  }
}

String _$photoRecoveryCommandHash() =>
    r'a4de3375449733de8334c909dbfb3f7b08975a5e';

/// Provides how the app can get access to more of the photos to recover.

@ProviderFor(devicePhotoAccessOption)
final devicePhotoAccessOptionProvider = DevicePhotoAccessOptionProvider._();

/// Provides how the app can get access to more of the photos to recover.

final class DevicePhotoAccessOptionProvider
    extends
        $FunctionalProvider<
          AsyncValue<DevicePhotoAccessOption>,
          DevicePhotoAccessOption,
          FutureOr<DevicePhotoAccessOption>
        >
    with
        $FutureModifier<DevicePhotoAccessOption>,
        $FutureProvider<DevicePhotoAccessOption> {
  /// Provides how the app can get access to more of the photos to recover.
  DevicePhotoAccessOptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devicePhotoAccessOptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devicePhotoAccessOptionHash();

  @$internal
  @override
  $FutureProviderElement<DevicePhotoAccessOption> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DevicePhotoAccessOption> create(Ref ref) {
    return devicePhotoAccessOption(ref);
  }
}

String _$devicePhotoAccessOptionHash() =>
    r'720196f78f3185076bbd2a35678d73eb8f7298b5';

/// Recovers photos. The state is the progress of the running recovery.

@ProviderFor(PhotoRecovery)
final photoRecoveryProvider = PhotoRecoveryProvider._();

/// Recovers photos. The state is the progress of the running recovery.
final class PhotoRecoveryProvider
    extends $NotifierProvider<PhotoRecovery, PhotoRecoveryStatus?> {
  /// Recovers photos. The state is the progress of the running recovery.
  PhotoRecoveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoRecoveryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoRecoveryHash();

  @$internal
  @override
  PhotoRecovery create() => PhotoRecovery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoRecoveryStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoRecoveryStatus?>(value),
    );
  }
}

String _$photoRecoveryHash() => r'fb19db275849b1019b1a595d02fa59aae42c3dc3';

/// Recovers photos. The state is the progress of the running recovery.

abstract class _$PhotoRecovery extends $Notifier<PhotoRecoveryStatus?> {
  PhotoRecoveryStatus? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PhotoRecoveryStatus?, PhotoRecoveryStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotoRecoveryStatus?, PhotoRecoveryStatus?>,
              PhotoRecoveryStatus?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
