// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'update_requester_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateRequesterHash() => r'8e297f3db152629cae40d3cf50de5d8161d02937';

/// アップデートを要求する責務を持つクラスを提供するプロバイダー。
///
/// Copied from [updateRequester].
@ProviderFor(updateRequester)
final updateRequesterProvider = AutoDisposeProvider<UpdateRequester>.internal(
  updateRequester,
  name: r'updateRequesterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateRequesterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateRequesterRef = AutoDisposeProviderRef<UpdateRequester>;
String _$updateRequestMessageHash() =>
    r'6d87aba3f2907def49be4da0711a3a76015227d9';

/// Compares the required Version setting with the actual app version to
/// determine if an update is necessary.
///
/// If an update is required, it provides an update prompt message.
/// If no update is needed, it returns null.
///
/// Copied from [updateRequestMessage].
@ProviderFor(updateRequestMessage)
final updateRequestMessageProvider = AutoDisposeProvider<String?>.internal(
  updateRequestMessage,
  name: r'updateRequestMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateRequestMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateRequestMessageRef = AutoDisposeProviderRef<String?>;
String _$updateRequestStateHash() =>
    r'a6bea312fbf33278019cf887759517b0d46b703b';

/// Provide the current [UpdateRequest].
///
/// Copied from [UpdateRequestState].
@ProviderFor(UpdateRequestState)
final updateRequestStateProvider =
    AutoDisposeNotifierProvider<UpdateRequestState, UpdateRequest>.internal(
  UpdateRequestState.new,
  name: r'updateRequestStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateRequestStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateRequestState = AutoDisposeNotifier<UpdateRequest>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
