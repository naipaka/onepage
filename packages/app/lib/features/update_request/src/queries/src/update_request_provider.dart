import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:version/version.dart';

import '../../../../../adapters/configurator_provider.dart';
import '../../models/models.dart';

part 'update_request_provider.g.dart';

/// The key for the [UpdateRequest] configuration.
const updateRequestKey = 'update_request';

/// The default value for the [UpdateRequest] configuration.
final updateRequestDefaultValue = jsonEncode(
  UpdateRequest(
    version: Version(1, 0, 0),
    message: '',
  ).toJson(),
);

/// Provide the current [UpdateRequest].
@riverpod
class UpdateRequestState extends _$UpdateRequestState {
  @override
  UpdateRequest build() {
    final configurator = ref.watch(configuratorProvider);
    final config = configurator.getDataConfig(
      updateRequestKey,
      fromJson: UpdateRequest.fromJson,
      onConfigUpdated: (value) => state = value,
    );
    ref.onDispose(config.dispose);
    return config.value;
  }
}
