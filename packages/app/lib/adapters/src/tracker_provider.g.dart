// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'tracker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [Tracker] provider.

@ProviderFor(tracker)
const trackerProvider = TrackerProvider._();

/// [Tracker] provider.

final class TrackerProvider
    extends $FunctionalProvider<Tracker, Tracker, Tracker>
    with $Provider<Tracker> {
  /// [Tracker] provider.
  const TrackerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackerHash();

  @$internal
  @override
  $ProviderElement<Tracker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Tracker create(Ref ref) {
    return tracker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Tracker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Tracker>(value),
    );
  }
}

String _$trackerHash() => r'8b77cc11d593f46376606aaa14800a713c90d7c9';
