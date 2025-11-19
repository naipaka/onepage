// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'haptics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the haptics service.
///
/// This provider creates a Haptics instance with the PrefsClient dependency
/// injected for preference-based haptic feedback control.

@ProviderFor(haptics)
const hapticsProvider = HapticsProvider._();

/// Provider for the haptics service.
///
/// This provider creates a Haptics instance with the PrefsClient dependency
/// injected for preference-based haptic feedback control.

final class HapticsProvider
    extends $FunctionalProvider<Haptics, Haptics, Haptics>
    with $Provider<Haptics> {
  /// Provider for the haptics service.
  ///
  /// This provider creates a Haptics instance with the PrefsClient dependency
  /// injected for preference-based haptic feedback control.
  const HapticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticsHash();

  @$internal
  @override
  $ProviderElement<Haptics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Haptics create(Ref ref) {
    return haptics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Haptics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Haptics>(value),
    );
  }
}

String _$hapticsHash() => r'e37a33bf276f8396ddd1f8f8b224e9b6e65cd7e7';
