// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A provider that creates a [DiaryCommand] instance.
///
/// {@macro diary.DiaryCommand}

@ProviderFor(diaryCommand)
const diaryCommandProvider = DiaryCommandProvider._();

/// A provider that creates a [DiaryCommand] instance.
///
/// {@macro diary.DiaryCommand}

final class DiaryCommandProvider
    extends $FunctionalProvider<DiaryCommand, DiaryCommand, DiaryCommand>
    with $Provider<DiaryCommand> {
  /// A provider that creates a [DiaryCommand] instance.
  ///
  /// {@macro diary.DiaryCommand}
  const DiaryCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryCommandProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryCommandHash();

  @$internal
  @override
  $ProviderElement<DiaryCommand> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiaryCommand create(Ref ref) {
    return diaryCommand(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryCommand value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryCommand>(value),
    );
  }
}

String _$diaryCommandHash() => r'ffb780d76c5eff004a8f280f5a8290afb6d36d89';

/// A provider that creates a [DiaryQuery] instance.
///
/// {@macro diary.DiaryQuery}

@ProviderFor(diaryQuery)
const diaryQueryProvider = DiaryQueryProvider._();

/// A provider that creates a [DiaryQuery] instance.
///
/// {@macro diary.DiaryQuery}

final class DiaryQueryProvider
    extends $FunctionalProvider<DiaryQuery, DiaryQuery, DiaryQuery>
    with $Provider<DiaryQuery> {
  /// A provider that creates a [DiaryQuery] instance.
  ///
  /// {@macro diary.DiaryQuery}
  const DiaryQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryQueryHash();

  @$internal
  @override
  $ProviderElement<DiaryQuery> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiaryQuery create(Ref ref) {
    return diaryQuery(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryQuery>(value),
    );
  }
}

String _$diaryQueryHash() => r'c2aaf09175f18fb5ff5d9eefca6e772125fae621';

/// Provides a list of diaries within the specified date range.

@ProviderFor(diaries)
const diariesProvider = DiariesFamily._();

/// Provides a list of diaries within the specified date range.

final class DiariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Diary>>,
          List<Diary>,
          FutureOr<List<Diary>>
        >
    with $FutureModifier<List<Diary>>, $FutureProvider<List<Diary>> {
  /// Provides a list of diaries within the specified date range.
  const DiariesProvider._({
    required DiariesFamily super.from,
    required ({DateTime fromDate, DateTime toDate}) super.argument,
  }) : super(
         retry: null,
         name: r'diariesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diariesHash();

  @override
  String toString() {
    return r'diariesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Diary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Diary>> create(Ref ref) {
    final argument = this.argument as ({DateTime fromDate, DateTime toDate});
    return diaries(ref, fromDate: argument.fromDate, toDate: argument.toDate);
  }

  @override
  bool operator ==(Object other) {
    return other is DiariesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diariesHash() => r'8637096a0bd9d9fce1e2e15c6d3a14b7f226ca84';

/// Provides a list of diaries within the specified date range.

final class DiariesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Diary>>,
          ({DateTime fromDate, DateTime toDate})
        > {
  const DiariesFamily._()
    : super(
        retry: null,
        name: r'diariesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a list of diaries within the specified date range.

  DiariesProvider call({
    required DateTime fromDate,
    required DateTime toDate,
  }) => DiariesProvider._(
    argument: (fromDate: fromDate, toDate: toDate),
    from: this,
  );

  @override
  String toString() => r'diariesProvider';
}

/// Provides a list of diaries with dates within the specified date range.

@ProviderFor(CachedDiaries)
const cachedDiariesProvider = CachedDiariesProvider._();

/// Provides a list of diaries with dates within the specified date range.
final class CachedDiariesProvider
    extends $AsyncNotifierProvider<CachedDiaries, DiariesWithDates> {
  /// Provides a list of diaries with dates within the specified date range.
  const CachedDiariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedDiariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedDiariesHash();

  @$internal
  @override
  CachedDiaries create() => CachedDiaries();
}

String _$cachedDiariesHash() => r'03c8f71ffeefee9f495013b5b6652380134d8085';

/// Provides a list of diaries with dates within the specified date range.

abstract class _$CachedDiaries extends $AsyncNotifier<DiariesWithDates> {
  FutureOr<DiariesWithDates> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<DiariesWithDates>, DiariesWithDates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DiariesWithDates>, DiariesWithDates>,
              AsyncValue<DiariesWithDates>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provides search functionality for diary entries.

@ProviderFor(DiarySearch)
const diarySearchProvider = DiarySearchProvider._();

/// Provides search functionality for diary entries.
final class DiarySearchProvider
    extends $NotifierProvider<DiarySearch, SearchResult> {
  /// Provides search functionality for diary entries.
  const DiarySearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diarySearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diarySearchHash();

  @$internal
  @override
  DiarySearch create() => DiarySearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchResult value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchResult>(value),
    );
  }
}

String _$diarySearchHash() => r'9655f6dd5d9515995bec8c6b4312b59f16dcd9fb';

/// Provides search functionality for diary entries.

abstract class _$DiarySearch extends $Notifier<SearchResult> {
  SearchResult build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchResult, SearchResult>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchResult, SearchResult>,
              SearchResult,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
