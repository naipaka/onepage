import 'package:flutter_test/flutter_test.dart';
import 'package:update_requester/src/models/src/update_request.dart';
import 'package:version/version.dart';

void main() {
  group('UpdateRequest', () {
    group('fromJson', () {
      test('should correctly parse JSON into UpdateRequest object', () {
        final json = {
          'version': '1.0.0',
          'message': 'Update available!',
        };
        final sut = UpdateRequest.fromJson(json);
        expect(sut.version, Version(1, 0, 0));
      });
    });

    group('toJson', () {
      test('should correctly convert UpdateRequest object to JSON', () {
        final updateRequest = UpdateRequest(
          version: Version(1, 0, 0),
          message: 'Update available!',
        );
        final sut = updateRequest.toJson();
        expect(sut, {
          'version': '1.0.0',
          'message': 'Update available!',
        });
      });
    });
  });
}
