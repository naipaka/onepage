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
final diaryCommandProvider = DiaryCommandProvider._();

/// A provider that creates a [DiaryCommand] instance.
///
/// {@macro diary.DiaryCommand}

final class DiaryCommandProvider
    extends $FunctionalProvider<DiaryCommand, DiaryCommand, DiaryCommand>
    with $Provider<DiaryCommand> {
  /// A provider that creates a [DiaryCommand] instance.
  ///
  /// {@macro diary.DiaryCommand}
  DiaryCommandProvider._()
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
final diaryQueryProvider = DiaryQueryProvider._();

/// A provider that creates a [DiaryQuery] instance.
///
/// {@macro diary.DiaryQuery}

final class DiaryQueryProvider
    extends $FunctionalProvider<DiaryQuery, DiaryQuery, DiaryQuery>
    with $Provider<DiaryQuery> {
  /// A provider that creates a [DiaryQuery] instance.
  ///
  /// {@macro diary.DiaryQuery}
  DiaryQueryProvider._()
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

/// Provides the diary images whose photo data is outside the app.
///
/// This is not a stream, because a paused stream keeps the database from
/// closing during a restore.

@ProviderFor(externalDiaryImages)
final externalDiaryImagesProvider = ExternalDiaryImagesProvider._();

/// Provides the diary images whose photo data is outside the app.
///
/// This is not a stream, because a paused stream keeps the database from
/// closing during a restore.

final class ExternalDiaryImagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DiaryImage>>,
          List<DiaryImage>,
          FutureOr<List<DiaryImage>>
        >
    with $FutureModifier<List<DiaryImage>>, $FutureProvider<List<DiaryImage>> {
  /// Provides the diary images whose photo data is outside the app.
  ///
  /// This is not a stream, because a paused stream keeps the database from
  /// closing during a restore.
  ExternalDiaryImagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'externalDiaryImagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$externalDiaryImagesHash();

  @$internal
  @override
  $FutureProviderElement<List<DiaryImage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DiaryImage>> create(Ref ref) {
    return externalDiaryImages(ref);
  }
}

String _$externalDiaryImagesHash() =>
    r'fe7dbb8b6e112b6ecac80e336af056f4df308ee2';

/// Provides a list of diaries within the specified date range.

@ProviderFor(diaries)
final diariesProvider = DiariesFamily._();

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
  DiariesProvider._({
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
  DiariesFamily._()
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
final cachedDiariesProvider = CachedDiariesProvider._();

/// Provides a list of diaries with dates within the specified date range.
final class CachedDiariesProvider
    extends $AsyncNotifierProvider<CachedDiaries, DiariesWithDates> {
  /// Provides a list of diaries with dates within the specified date range.
  CachedDiariesProvider._()
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

String _$cachedDiariesHash() => r'539fd80266cfd30ae39983e183ec99bc58f59d33';

/// Provides a list of diaries with dates within the specified date range.

abstract class _$CachedDiaries extends $AsyncNotifier<DiariesWithDates> {
  FutureOr<DiariesWithDates> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
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
    return element.handleCreate(ref, build);
  }
}

/// The minimum length of a diary search term.
///
/// {@macro diary.DiaryQuery.minSearchTermLength}

@ProviderFor(minDiarySearchTermLength)
final minDiarySearchTermLengthProvider = MinDiarySearchTermLengthProvider._();

/// The minimum length of a diary search term.
///
/// {@macro diary.DiaryQuery.minSearchTermLength}

final class MinDiarySearchTermLengthProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// The minimum length of a diary search term.
  ///
  /// {@macro diary.DiaryQuery.minSearchTermLength}
  MinDiarySearchTermLengthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'minDiarySearchTermLengthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$minDiarySearchTermLengthHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return minDiarySearchTermLength(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$minDiarySearchTermLengthHash() =>
    r'2c0231b3fa43f380af4760ba9823e3a29cb16f73';

/// {@template onepage.DiarySearchSession}
/// The diary search that the search dialog shows, kept until the app closes
/// so that the dialog opens again where the user left it.
///
/// The term is the input without the spaces around it, and is empty when
/// nothing is searched.
/// {@endtemplate}

@ProviderFor(DiarySearchSession)
final diarySearchSessionProvider = DiarySearchSessionProvider._();

/// {@template onepage.DiarySearchSession}
/// The diary search that the search dialog shows, kept until the app closes
/// so that the dialog opens again where the user left it.
///
/// The term is the input without the spaces around it, and is empty when
/// nothing is searched.
/// {@endtemplate}
final class DiarySearchSessionProvider
    extends $NotifierProvider<DiarySearchSession, DiarySearchPlace> {
  /// {@template onepage.DiarySearchSession}
  /// The diary search that the search dialog shows, kept until the app closes
  /// so that the dialog opens again where the user left it.
  ///
  /// The term is the input without the spaces around it, and is empty when
  /// nothing is searched.
  /// {@endtemplate}
  DiarySearchSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diarySearchSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diarySearchSessionHash();

  @$internal
  @override
  DiarySearchSession create() => DiarySearchSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiarySearchPlace value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiarySearchPlace>(value),
    );
  }
}

String _$diarySearchSessionHash() =>
    r'f8adaf2a6e190be2b6be0578f68f33ebd0e7c6d7';

/// {@template onepage.DiarySearchSession}
/// The diary search that the search dialog shows, kept until the app closes
/// so that the dialog opens again where the user left it.
///
/// The term is the input without the spaces around it, and is empty when
/// nothing is searched.
/// {@endtemplate}

abstract class _$DiarySearchSession extends $Notifier<DiarySearchPlace> {
  DiarySearchPlace build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DiarySearchPlace, DiarySearchPlace>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiarySearchPlace, DiarySearchPlace>,
              DiarySearchPlace,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// {@template onepage.DiarySearchResults}
/// The diary entries that contain a search term, the newest first, loaded
/// a page at a time.
///
/// The results of the term of [DiarySearchSession] stay after the search
/// dialog closes, and the others are disposed when nothing watches them.
/// An empty term has no entries, and searches nothing.
/// A failure to load more entries keeps the loaded ones in the state.
/// {@endtemplate}

@ProviderFor(DiarySearchResults)
final diarySearchResultsProvider = DiarySearchResultsFamily._();

/// {@template onepage.DiarySearchResults}
/// The diary entries that contain a search term, the newest first, loaded
/// a page at a time.
///
/// The results of the term of [DiarySearchSession] stay after the search
/// dialog closes, and the others are disposed when nothing watches them.
/// An empty term has no entries, and searches nothing.
/// A failure to load more entries keeps the loaded ones in the state.
/// {@endtemplate}
final class DiarySearchResultsProvider
    extends $AsyncNotifierProvider<DiarySearchResults, LoadedDiaryEntries> {
  /// {@template onepage.DiarySearchResults}
  /// The diary entries that contain a search term, the newest first, loaded
  /// a page at a time.
  ///
  /// The results of the term of [DiarySearchSession] stay after the search
  /// dialog closes, and the others are disposed when nothing watches them.
  /// An empty term has no entries, and searches nothing.
  /// A failure to load more entries keeps the loaded ones in the state.
  /// {@endtemplate}
  DiarySearchResultsProvider._({
    required DiarySearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'diarySearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diarySearchResultsHash();

  @override
  String toString() {
    return r'diarySearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiarySearchResults create() => DiarySearchResults();

  @override
  bool operator ==(Object other) {
    return other is DiarySearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diarySearchResultsHash() =>
    r'f57cae3c6841a13d75a2cbaad726c41a6483ab60';

/// {@template onepage.DiarySearchResults}
/// The diary entries that contain a search term, the newest first, loaded
/// a page at a time.
///
/// The results of the term of [DiarySearchSession] stay after the search
/// dialog closes, and the others are disposed when nothing watches them.
/// An empty term has no entries, and searches nothing.
/// A failure to load more entries keeps the loaded ones in the state.
/// {@endtemplate}

final class DiarySearchResultsFamily extends $Family
    with
        $ClassFamilyOverride<
          DiarySearchResults,
          AsyncValue<LoadedDiaryEntries>,
          LoadedDiaryEntries,
          FutureOr<LoadedDiaryEntries>,
          String
        > {
  DiarySearchResultsFamily._()
    : super(
        retry: null,
        name: r'diarySearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// {@template onepage.DiarySearchResults}
  /// The diary entries that contain a search term, the newest first, loaded
  /// a page at a time.
  ///
  /// The results of the term of [DiarySearchSession] stay after the search
  /// dialog closes, and the others are disposed when nothing watches them.
  /// An empty term has no entries, and searches nothing.
  /// A failure to load more entries keeps the loaded ones in the state.
  /// {@endtemplate}

  DiarySearchResultsProvider call(String term) =>
      DiarySearchResultsProvider._(argument: term, from: this);

  @override
  String toString() => r'diarySearchResultsProvider';
}

/// {@template onepage.DiarySearchResults}
/// The diary entries that contain a search term, the newest first, loaded
/// a page at a time.
///
/// The results of the term of [DiarySearchSession] stay after the search
/// dialog closes, and the others are disposed when nothing watches them.
/// An empty term has no entries, and searches nothing.
/// A failure to load more entries keeps the loaded ones in the state.
/// {@endtemplate}

abstract class _$DiarySearchResults extends $AsyncNotifier<LoadedDiaryEntries> {
  late final _$args = ref.$arg as String;
  String get term => _$args;

  FutureOr<LoadedDiaryEntries> build(String term);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<LoadedDiaryEntries>, LoadedDiaryEntries>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoadedDiaryEntries>, LoadedDiaryEntries>,
              AsyncValue<LoadedDiaryEntries>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
