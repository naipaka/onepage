// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'photo_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the photo file storage.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.

@ProviderFor(photoStorage)
final photoStorageProvider = PhotoStorageProvider._();

/// Provider for the photo file storage.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.

final class PhotoStorageProvider
    extends $FunctionalProvider<PhotoStorage, PhotoStorage, PhotoStorage>
    with $Provider<PhotoStorage> {
  /// Provider for the photo file storage.
  ///
  /// This provider must be overridden in main.dart with an initialized instance.
  /// By default, it throws UnimplementedError to ensure proper initialization.
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

String _$photoStorageHash() => r'4ce07f72303ff9e1820f34dfc487bd2243d53a4c';

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
