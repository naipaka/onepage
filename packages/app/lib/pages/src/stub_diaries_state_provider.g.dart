// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'stub_diaries_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// For mocking diaries state.

@ProviderFor(StubDiariesState)
const stubDiariesStateProvider = StubDiariesStateProvider._();

/// For mocking diaries state.
final class StubDiariesStateProvider
    extends $AsyncNotifierProvider<StubDiariesState, List<_Diary>> {
  /// For mocking diaries state.
  const StubDiariesStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stubDiariesStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stubDiariesStateHash();

  @$internal
  @override
  StubDiariesState create() => StubDiariesState();
}

String _$stubDiariesStateHash() => r'8c101b0f71a422f63a830dc0325b316ac27f29c8';

/// For mocking diaries state.

abstract class _$StubDiariesState extends $AsyncNotifier<List<_Diary>> {
  FutureOr<List<_Diary>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<_Diary>>, List<_Diary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<_Diary>>, List<_Diary>>,
              AsyncValue<List<_Diary>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
