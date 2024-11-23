import 'package:json_annotation/json_annotation.dart';
import 'package:version/version.dart';

/// A converter that converts a [Version] to a [String] and vice versa.
const versionConverter = VersionConverter();

/// A converter that converts a [Version] to a [String] and vice versa.
class VersionConverter implements JsonConverter<Version, String> {
  /// Creates a new [VersionConverter].
  const VersionConverter();

  @override
  Version fromJson(String json) => Version.parse(json);

  @override
  String toJson(Version version) => version.toString();
}
