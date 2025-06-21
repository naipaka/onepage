// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'haptics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hapticsHash() => r'e37a33bf276f8396ddd1f8f8b224e9b6e65cd7e7';

/// Provider for the haptics service.
///
/// This provider creates a Haptics instance with the PrefsClient dependency
/// injected for preference-based haptic feedback control.
///
/// Copied from [haptics].
@ProviderFor(haptics)
final hapticsProvider = AutoDisposeProvider<Haptics>.internal(
  haptics,
  name: r'hapticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hapticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HapticsRef = AutoDisposeProviderRef<Haptics>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
