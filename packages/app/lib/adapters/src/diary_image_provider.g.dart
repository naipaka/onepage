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
final diaryImageCommandProvider = DiaryImageCommandProvider._();

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
  DiaryImageCommandProvider._()
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

String _$diaryImageCommandHash() => r'dd04f8f82efdd39f98a7ee602333ea0455bdcf0b';

/// Whether a picked photo is being saved.

@ProviderFor(DiaryImageSaving)
final diaryImageSavingProvider = DiaryImageSavingProvider._();

/// Whether a picked photo is being saved.
final class DiaryImageSavingProvider
    extends $NotifierProvider<DiaryImageSaving, bool> {
  /// Whether a picked photo is being saved.
  DiaryImageSavingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryImageSavingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryImageSavingHash();

  @$internal
  @override
  DiaryImageSaving create() => DiaryImageSaving();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$diaryImageSavingHash() => r'daa2bd8cee7af8c7b9f32b8fc2f79ef092126e36';

/// Whether a picked photo is being saved.

abstract class _$DiaryImageSaving extends $Notifier<bool> {
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
