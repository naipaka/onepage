// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'flavor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provide current Flavor.
///
/// Need override in top-level ProviderScope.

@ProviderFor(flavor)
const flavorProvider = FlavorProvider._();

/// Provide current Flavor.
///
/// Need override in top-level ProviderScope.

final class FlavorProvider extends $FunctionalProvider<Flavor, Flavor, Flavor>
    with $Provider<Flavor> {
  /// Provide current Flavor.
  ///
  /// Need override in top-level ProviderScope.
  const FlavorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flavorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flavorHash();

  @$internal
  @override
  $ProviderElement<Flavor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Flavor create(Ref ref) {
    return flavor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Flavor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Flavor>(value),
    );
  }
}

String _$flavorHash() => r'034afac5cb627981977cb9398af6b8329eb70c03';
