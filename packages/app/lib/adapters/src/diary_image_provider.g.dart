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
