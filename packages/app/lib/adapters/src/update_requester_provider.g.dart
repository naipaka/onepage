// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'update_requester_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that supplies a class responsible for requesting updates.

@ProviderFor(updateRequester)
const updateRequesterProvider = UpdateRequesterProvider._();

/// Provider that supplies a class responsible for requesting updates.

final class UpdateRequesterProvider
    extends
        $FunctionalProvider<UpdateRequester, UpdateRequester, UpdateRequester>
    with $Provider<UpdateRequester> {
  /// Provider that supplies a class responsible for requesting updates.
  const UpdateRequesterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateRequesterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateRequesterHash();

  @$internal
  @override
  $ProviderElement<UpdateRequester> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateRequester create(Ref ref) {
    return updateRequester(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateRequester value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateRequester>(value),
    );
  }
}

String _$updateRequesterHash() => r'8e297f3db152629cae40d3cf50de5d8161d02937';

/// Provides the current [UpdateRequest] state.
///
/// {@macro update_requester.UpdateRequest}

@ProviderFor(UpdateRequestState)
const updateRequestStateProvider = UpdateRequestStateProvider._();

/// Provides the current [UpdateRequest] state.
///
/// {@macro update_requester.UpdateRequest}
final class UpdateRequestStateProvider
    extends $NotifierProvider<UpdateRequestState, UpdateRequest> {
  /// Provides the current [UpdateRequest] state.
  ///
  /// {@macro update_requester.UpdateRequest}
  const UpdateRequestStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateRequestStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateRequestStateHash();

  @$internal
  @override
  UpdateRequestState create() => UpdateRequestState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateRequest>(value),
    );
  }
}

String _$updateRequestStateHash() =>
    r'a6bea312fbf33278019cf887759517b0d46b703b';

/// Provides the current [UpdateRequest] state.
///
/// {@macro update_requester.UpdateRequest}

abstract class _$UpdateRequestState extends $Notifier<UpdateRequest> {
  UpdateRequest build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UpdateRequest, UpdateRequest>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UpdateRequest, UpdateRequest>,
              UpdateRequest,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Compares the required Version setting with the actual app version to
/// determine if an update is necessary.
///
/// If an update is required, it provides an update prompt message.
/// If no update is needed, it returns null.

@ProviderFor(updateRequestMessage)
const updateRequestMessageProvider = UpdateRequestMessageProvider._();

/// Compares the required Version setting with the actual app version to
/// determine if an update is necessary.
///
/// If an update is required, it provides an update prompt message.
/// If no update is needed, it returns null.

final class UpdateRequestMessageProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Compares the required Version setting with the actual app version to
  /// determine if an update is necessary.
  ///
  /// If an update is required, it provides an update prompt message.
  /// If no update is needed, it returns null.
  const UpdateRequestMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateRequestMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateRequestMessageHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return updateRequestMessage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$updateRequestMessageHash() =>
    r'6d87aba3f2907def49be4da0711a3a76015227d9';
