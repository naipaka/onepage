import 'package:flutter/foundation.dart';
import 'package:version/version.dart';

/// {@template update_requester.UpdateRequest}
/// A request to prompt for an app update.
///
/// This class is used to request an app update from the user.
/// {@endtemplate}
@immutable
class UpdateRequest {
  /// {@macro update_requester.UpdateRequest}
  const new({
    required this.version,
    required this.message,
  });

  /// {@macro update_requester.UpdateRequest}
  ///
  /// Returns a new [UpdateRequest] from a JSON object.
  factory fromJson(Map<String, Object?> json) => UpdateRequest(
    version: Version.parse(json['version']! as String),
    message: json['message']! as String,
  );

  /// The version of the app being requested.
  final Version version;

  /// The message prompting the app update.
  final String message;

  /// Converts this request to JSON.
  Map<String, Object?> toJson() => <String, Object?>{
    'version': version.toString(),
    'message': message,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UpdateRequest &&
        other.version == version &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(version, message);

  @override
  String toString() => 'UpdateRequest(version: $version, message: $message)';
}
