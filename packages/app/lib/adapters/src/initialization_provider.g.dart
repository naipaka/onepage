// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'initialization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers that need to initialize asynchronously only once at startup.

@ProviderFor(initialization)
const initializationProvider = InitializationProvider._();

/// Providers that need to initialize asynchronously only once at startup.

final class InitializationProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Providers that need to initialize asynchronously only once at startup.
  const InitializationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initializationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initializationHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initialization(ref);
  }
}

String _$initializationHash() => r'd1c9475238fb5c85714023db6ac60c5ccdc71c15';
