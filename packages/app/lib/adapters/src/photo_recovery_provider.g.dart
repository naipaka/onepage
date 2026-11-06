// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'photo_recovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the device photo library.

@ProviderFor(photoLibrary)
final photoLibraryProvider = PhotoLibraryProvider._();

/// Provides the device photo library.

final class PhotoLibraryProvider
    extends $FunctionalProvider<PhotoLibrary, PhotoLibrary, PhotoLibrary>
    with $Provider<PhotoLibrary> {
  /// Provides the device photo library.
  PhotoLibraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoLibraryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoLibraryHash();

  @$internal
  @override
  $ProviderElement<PhotoLibrary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoLibrary create(Ref ref) {
    return photoLibrary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoLibrary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoLibrary>(value),
    );
  }
}

String _$photoLibraryHash() => r'8276c34458d4f24c7ab3a3c164fbe1b02d5716c0';

/// Provides the diary images that are not stored in the app.
///
/// This is not a stream, because a paused stream keeps the database from
/// closing during a restore.

@ProviderFor(unmigratedDiaryImages)
final unmigratedDiaryImagesProvider = UnmigratedDiaryImagesProvider._();

/// Provides the diary images that are not stored in the app.
///
/// This is not a stream, because a paused stream keeps the database from
/// closing during a restore.

final class UnmigratedDiaryImagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DiaryImage>>,
          List<DiaryImage>,
          FutureOr<List<DiaryImage>>
        >
    with $FutureModifier<List<DiaryImage>>, $FutureProvider<List<DiaryImage>> {
  /// Provides the diary images that are not stored in the app.
  ///
  /// This is not a stream, because a paused stream keeps the database from
  /// closing during a restore.
  UnmigratedDiaryImagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unmigratedDiaryImagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unmigratedDiaryImagesHash();

  @$internal
  @override
  $FutureProviderElement<List<DiaryImage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DiaryImage>> create(Ref ref) {
    return unmigratedDiaryImages(ref);
  }
}

String _$unmigratedDiaryImagesHash() =>
    r'685b7ff86443097e4355db7918e0459ba5f5c2c1';

/// A provider that creates a [PhotoRecoveryCommand] instance.
///
/// {@macro diary.PhotoRecoveryCommand}

@ProviderFor(photoRecoveryCommand)
final photoRecoveryCommandProvider = PhotoRecoveryCommandProvider._();

/// A provider that creates a [PhotoRecoveryCommand] instance.
///
/// {@macro diary.PhotoRecoveryCommand}

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
  /// {@macro diary.PhotoRecoveryCommand}
  PhotoRecoveryCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoRecoveryCommandProvider',
        isAutoDispose: true,
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
    r'6a22f7eaa378ba29aa2e45ca2aafeda02db5cfc1';

/// Recovers photos and reports the progress.

@ProviderFor(PhotoRecovery)
final photoRecoveryProvider = PhotoRecoveryProvider._();

/// Recovers photos and reports the progress.
final class PhotoRecoveryProvider
    extends $NotifierProvider<PhotoRecovery, PhotoRecoveryState> {
  /// Recovers photos and reports the progress.
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
  Override overrideWithValue(PhotoRecoveryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoRecoveryState>(value),
    );
  }
}

String _$photoRecoveryHash() => r'ac04c527d7731f3b8fd91aa62727071be72e8603';

/// Recovers photos and reports the progress.

abstract class _$PhotoRecovery extends $Notifier<PhotoRecoveryState> {
  PhotoRecoveryState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PhotoRecoveryState, PhotoRecoveryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotoRecoveryState, PhotoRecoveryState>,
              PhotoRecoveryState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
