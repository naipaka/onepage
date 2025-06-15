// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$diaryCommandHash() => r'ffb780d76c5eff004a8f280f5a8290afb6d36d89';

/// A provider that creates a [DiaryCommand] instance.
///
/// {@macro diary.DiaryCommand}
///
/// Copied from [diaryCommand].
@ProviderFor(diaryCommand)
final diaryCommandProvider = Provider<DiaryCommand>.internal(
  diaryCommand,
  name: r'diaryCommandProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$diaryCommandHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiaryCommandRef = ProviderRef<DiaryCommand>;
String _$diaryQueryHash() => r'c2aaf09175f18fb5ff5d9eefca6e772125fae621';

/// A provider that creates a [DiaryQuery] instance.
///
/// {@macro diary.DiaryQuery}
///
/// Copied from [diaryQuery].
@ProviderFor(diaryQuery)
final diaryQueryProvider = Provider<DiaryQuery>.internal(
  diaryQuery,
  name: r'diaryQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$diaryQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiaryQueryRef = ProviderRef<DiaryQuery>;
String _$diariesHash() => r'8637096a0bd9d9fce1e2e15c6d3a14b7f226ca84';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provides a list of diaries within the specified date range.
///
/// Copied from [diaries].
@ProviderFor(diaries)
const diariesProvider = DiariesFamily();

/// Provides a list of diaries within the specified date range.
///
/// Copied from [diaries].
class DiariesFamily extends Family<AsyncValue<List<Diary>>> {
  /// Provides a list of diaries within the specified date range.
  ///
  /// Copied from [diaries].
  const DiariesFamily();

  /// Provides a list of diaries within the specified date range.
  ///
  /// Copied from [diaries].
  DiariesProvider call({required DateTime fromDate, required DateTime toDate}) {
    return DiariesProvider(fromDate: fromDate, toDate: toDate);
  }

  @override
  DiariesProvider getProviderOverride(covariant DiariesProvider provider) {
    return call(fromDate: provider.fromDate, toDate: provider.toDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'diariesProvider';
}

/// Provides a list of diaries within the specified date range.
///
/// Copied from [diaries].
class DiariesProvider extends AutoDisposeFutureProvider<List<Diary>> {
  /// Provides a list of diaries within the specified date range.
  ///
  /// Copied from [diaries].
  DiariesProvider({required DateTime fromDate, required DateTime toDate})
    : this._internal(
        (ref) => diaries(ref as DiariesRef, fromDate: fromDate, toDate: toDate),
        from: diariesProvider,
        name: r'diariesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$diariesHash,
        dependencies: DiariesFamily._dependencies,
        allTransitiveDependencies: DiariesFamily._allTransitiveDependencies,
        fromDate: fromDate,
        toDate: toDate,
      );

  DiariesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.fromDate,
    required this.toDate,
  }) : super.internal();

  final DateTime fromDate;
  final DateTime toDate;

  @override
  Override overrideWith(
    FutureOr<List<Diary>> Function(DiariesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DiariesProvider._internal(
        (ref) => create(ref as DiariesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Diary>> createElement() {
    return _DiariesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DiariesProvider &&
        other.fromDate == fromDate &&
        other.toDate == toDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, fromDate.hashCode);
    hash = _SystemHash.combine(hash, toDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DiariesRef on AutoDisposeFutureProviderRef<List<Diary>> {
  /// The parameter `fromDate` of this provider.
  DateTime get fromDate;

  /// The parameter `toDate` of this provider.
  DateTime get toDate;
}

class _DiariesProviderElement
    extends AutoDisposeFutureProviderElement<List<Diary>>
    with DiariesRef {
  _DiariesProviderElement(super.provider);

  @override
  DateTime get fromDate => (origin as DiariesProvider).fromDate;
  @override
  DateTime get toDate => (origin as DiariesProvider).toDate;
}

String _$cachedDiariesHash() => r'574d8d16dbca2b8af1dd5f485ff555e288c35f09';

/// Provides a list of diaries with dates within the specified date range.
///
/// Copied from [CachedDiaries].
@ProviderFor(CachedDiaries)
final cachedDiariesProvider =
    AutoDisposeAsyncNotifierProvider<CachedDiaries, DiariesWithDates>.internal(
      CachedDiaries.new,
      name: r'cachedDiariesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cachedDiariesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CachedDiaries = AutoDisposeAsyncNotifier<DiariesWithDates>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
