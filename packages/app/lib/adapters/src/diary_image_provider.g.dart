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

String _$diaryImageCommandHash() => r'bba5a38ec8b23221602569274b0d7027f3dfb282';
