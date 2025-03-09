import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:version/version.dart';

import 'version_converter.dart';

part 'update_request.freezed.dart';
part 'update_request.g.dart';

/// {@template update_requester.UpdateRequest}
/// A request to prompt for an app update.
///
/// This class is used to request an app update from the user.
/// {@endtemplate}
@freezed
abstract class UpdateRequest with _$UpdateRequest {
  /// {@macro update_requester.UpdateRequest}
  const factory UpdateRequest({
    /// The version of the app being requested.
    @versionConverter required Version version,

    /// The message prompting the app update.
    required String message,
  }) = _UpdateRequest;

  /// {@macro update_requester.UpdateRequest}
  ///
  /// Returns a new [UpdateRequest] from a JSON object.
  factory UpdateRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateRequestFromJson(json);
}
