// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'photo_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creates the photo file storage once at startup.

@ProviderFor(photoStorageInitializing)
final photoStorageInitializingProvider = PhotoStorageInitializingProvider._();

/// Creates the photo file storage once at startup.

final class PhotoStorageInitializingProvider
    extends
        $FunctionalProvider<
          AsyncValue<PhotoStorage>,
          PhotoStorage,
          FutureOr<PhotoStorage>
        >
    with $FutureModifier<PhotoStorage>, $FutureProvider<PhotoStorage> {
  /// Creates the photo file storage once at startup.
  PhotoStorageInitializingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoStorageInitializingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoStorageInitializingHash();

  @$internal
  @override
  $FutureProviderElement<PhotoStorage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PhotoStorage> create(Ref ref) {
    return photoStorageInitializing(ref);
  }
}

String _$photoStorageInitializingHash() =>
    r'7d594e620d4ede7fb202b096638b77c958329086';

/// Provider for the photo file storage.
///
/// Throws until [photoStorageInitializingProvider] completes, which
/// `initializationProvider` waits for before the app shows any page.

@ProviderFor(photoStorage)
final photoStorageProvider = PhotoStorageProvider._();

/// Provider for the photo file storage.
///
/// Throws until [photoStorageInitializingProvider] completes, which
/// `initializationProvider` waits for before the app shows any page.

final class PhotoStorageProvider
    extends $FunctionalProvider<PhotoStorage, PhotoStorage, PhotoStorage>
    with $Provider<PhotoStorage> {
  /// Provider for the photo file storage.
  ///
  /// Throws until [photoStorageInitializingProvider] completes, which
  /// `initializationProvider` waits for before the app shows any page.
  PhotoStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoStorageHash();

  @$internal
  @override
  $ProviderElement<PhotoStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoStorage create(Ref ref) {
    return photoStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoStorage>(value),
    );
  }
}

String _$photoStorageHash() => r'202b47322900b61c74a5d619ff587d41338aa8d9';

/// Provider for the file of a stored photo.

@ProviderFor(photoFile)
final photoFileProvider = PhotoFileFamily._();

/// Provider for the file of a stored photo.

final class PhotoFileProvider extends $FunctionalProvider<File, File, File>
    with $Provider<File> {
  /// Provider for the file of a stored photo.
  PhotoFileProvider._({
    required PhotoFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'photoFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$photoFileHash();

  @override
  String toString() {
    return r'photoFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<File> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  File create(Ref ref) {
    final argument = this.argument as String;
    return photoFile(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(File value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<File>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$photoFileHash() => r'747454b410e4efd762d188428abc4adb6fd9d678';

/// Provider for the file of a stored photo.

final class PhotoFileFamily extends $Family
    with $FunctionalFamilyOverride<File, String> {
  PhotoFileFamily._()
    : super(
        retry: null,
        name: r'photoFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for the file of a stored photo.

  PhotoFileProvider call(String fileName) =>
      PhotoFileProvider._(argument: fileName, from: this);

  @override
  String toString() => r'photoFileProvider';
}
