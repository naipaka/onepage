import 'package:flutter_test/flutter_test.dart';
import 'package:update_requester/src/models/src/version_converter.dart';
import 'package:version/version.dart';

void main() {
  group('VersionConverter', () {
    const converter = VersionConverter();

    group('fromJson', () {
      test('should correctly parse JSON string into Version object', () {
        const jsonString = '1.0.0';
        final sut = converter.fromJson(jsonString);
        expect(sut, Version(1, 0, 0));
      });

      test('should throw FormatException for invalid version string', () {
        const invalidJsonString = 'invalid_version';
        expect(
          () => converter.fromJson(invalidJsonString),
          throwsFormatException,
        );
      });
    });

    group('toJson', () {
      test('should correctly convert Version object to JSON string', () {
        final version = Version(1, 0, 0);
        final sut = converter.toJson(version);
        expect(sut, '1.0.0');
      });
    });
  });
}
