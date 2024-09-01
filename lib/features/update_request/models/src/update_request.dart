import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:version/version.dart';

import 'version_converter.dart';

part 'update_request.freezed.dart';
part 'update_request.g.dart';

/// A request to prompt for an app update.
@freezed
class UpdateRequest with _$UpdateRequest {
  /// Creates a new [UpdateRequest].
  const factory UpdateRequest({
    /// The version of the app being requested.
    @versionConverter required Version version,

    /// The message prompting the app update.
    required String message,
  }) = _UpdateRequest;

  /// Creates a new [UpdateRequest] from a JSON object.
  factory UpdateRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateRequestFromJson(json);
}
