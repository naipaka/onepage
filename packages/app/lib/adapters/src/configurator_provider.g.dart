// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'configurator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Initialize the [Configurator] and set the default values.

@ProviderFor(configuratorInitializing)
const configuratorInitializingProvider = ConfiguratorInitializingProvider._();

/// Initialize the [Configurator] and set the default values.

final class ConfiguratorInitializingProvider
    extends
        $FunctionalProvider<
          AsyncValue<Configurator>,
          Configurator,
          FutureOr<Configurator>
        >
    with $FutureModifier<Configurator>, $FutureProvider<Configurator> {
  /// Initialize the [Configurator] and set the default values.
  const ConfiguratorInitializingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configuratorInitializingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configuratorInitializingHash();

  @$internal
  @override
  $FutureProviderElement<Configurator> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Configurator> create(Ref ref) {
    return configuratorInitializing(ref);
  }
}

String _$configuratorInitializingHash() =>
    r'29c83e1a62006388d30891211dbc0e539c86df9a';

/// A provider that manages the [Configurator].

@ProviderFor(configurator)
const configuratorProvider = ConfiguratorProvider._();

/// A provider that manages the [Configurator].

final class ConfiguratorProvider
    extends $FunctionalProvider<Configurator, Configurator, Configurator>
    with $Provider<Configurator> {
  /// A provider that manages the [Configurator].
  const ConfiguratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configuratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configuratorHash();

  @$internal
  @override
  $ProviderElement<Configurator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Configurator create(Ref ref) {
    return configurator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Configurator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Configurator>(value),
    );
  }
}

String _$configuratorHash() => r'4d570762b760fa3a8a6af236aa327b7a6602714c';
