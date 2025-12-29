// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A provider that creates a [DiaryImageCommand] instance.
///
/// {@macro diary.DiaryImageCommand}

@ProviderFor(diaryImageCommand)
const diaryImageCommandProvider = DiaryImageCommandProvider._();

/// A provider that creates a [DiaryImageCommand] instance.
///
/// {@macro diary.DiaryImageCommand}

final class DiaryImageCommandProvider
    extends
        $FunctionalProvider<
          DiaryImageCommand,
          DiaryImageCommand,
          DiaryImageCommand
        >
    with $Provider<DiaryImageCommand> {
  /// A provider that creates a [DiaryImageCommand] instance.
  ///
  /// {@macro diary.DiaryImageCommand}
  const DiaryImageCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryImageCommandProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryImageCommandHash();

  @$internal
  @override
  $ProviderElement<DiaryImageCommand> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiaryImageCommand create(Ref ref) {
    return diaryImageCommand(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryImageCommand value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryImageCommand>(value),
    );
  }
}

String _$diaryImageCommandHash() => r'313969a0d587f77cd6f27a825f125e843c0e4c99';

/// A provider that creates a [DiaryImageQuery] instance.
///
/// {@macro diary.DiaryImageQuery}

@ProviderFor(diaryImageQuery)
const diaryImageQueryProvider = DiaryImageQueryProvider._();

/// A provider that creates a [DiaryImageQuery] instance.
///
/// {@macro diary.DiaryImageQuery}

final class DiaryImageQueryProvider
    extends
        $FunctionalProvider<DiaryImageQuery, DiaryImageQuery, DiaryImageQuery>
    with $Provider<DiaryImageQuery> {
  /// A provider that creates a [DiaryImageQuery] instance.
  ///
  /// {@macro diary.DiaryImageQuery}
  const DiaryImageQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryImageQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryImageQueryHash();

  @$internal
  @override
  $ProviderElement<DiaryImageQuery> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiaryImageQuery create(Ref ref) {
    return diaryImageQuery(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryImageQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryImageQuery>(value),
    );
  }
}

String _$diaryImageQueryHash() => r'3ed9a31438e5545bc4c57a9eb804b5a3cccb7134';

/// Provides a list of diary images for a specific diary entry.

@ProviderFor(diaryImages)
const diaryImagesProvider = DiaryImagesFamily._();

/// Provides a list of diary images for a specific diary entry.

final class DiaryImagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DiaryImage>>,
          List<DiaryImage>,
          FutureOr<List<DiaryImage>>
        >
    with $FutureModifier<List<DiaryImage>>, $FutureProvider<List<DiaryImage>> {
  /// Provides a list of diary images for a specific diary entry.
  const DiaryImagesProvider._({
    required DiaryImagesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'diaryImagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryImagesHash();

  @override
  String toString() {
    return r'diaryImagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DiaryImage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DiaryImage>> create(Ref ref) {
    final argument = this.argument as int;
    return diaryImages(ref, diaryId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiaryImagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryImagesHash() => r'48d5dcff3451247ea5b895f94284fa7e4c5190d1';

/// Provides a list of diary images for a specific diary entry.

final class DiaryImagesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DiaryImage>>, int> {
  const DiaryImagesFamily._()
    : super(
        retry: null,
        name: r'diaryImagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a list of diary images for a specific diary entry.

  DiaryImagesProvider call({required int diaryId}) =>
      DiaryImagesProvider._(argument: diaryId, from: this);

  @override
  String toString() => r'diaryImagesProvider';
}
