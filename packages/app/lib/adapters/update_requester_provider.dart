import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:update_requester/update_requester.dart';

import '../../adapters/configurator_provider.dart';

part 'update_requester_provider.g.dart';

/// Provider that supplies a class responsible for requesting updates.
@riverpod
UpdateRequester updateRequester(Ref ref) {
  final configurator = ref.watch(configuratorProvider);
  final packageInfo = ref.watch(packageInfoProvider);
  return UpdateRequester(
    configurator: configurator,
    packageInfo: packageInfo,
  );
}

/// Provides the current [UpdateRequest].
@riverpod
class UpdateRequestState extends _$UpdateRequestState {
  /// Builds the initial state of the [UpdateRequest].
  ///
  /// This method watches the [updateRequesterProvider] to get an instance of
  /// [UpdateRequester]. It then calls [UpdateRequester.getConfig] to get the
  /// current configuration and sets up a listener to update the state when the
  /// configuration changes. The configuration is disposed of when this provider
  /// is disposed.
  ///
  /// Returns the current [UpdateRequest] value.
  @override
  UpdateRequest build() {
    final updateRequester = ref.watch(updateRequesterProvider);
    final config = updateRequester.getConfig(
      onConfigUpdated: (value) => state = value,
    );
    ref.onDispose(config.dispose);
    return config.value;
  }
}

/// Compares the required Version setting with the actual app version to
/// determine if an update is necessary.
///
/// If an update is required, it provides an update prompt message.
/// If no update is needed, it returns null.
@riverpod
String? updateRequestMessage(Ref ref) {
  final updateRequester = ref.watch(updateRequesterProvider);
  final updateRequest = ref.watch(updateRequestStateProvider);
  return updateRequester.updateRequestMessage(updateRequest);
}
