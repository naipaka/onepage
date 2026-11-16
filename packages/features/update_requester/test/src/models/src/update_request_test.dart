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
        expect(sut.message, 'Update available!');
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

    group('equality', () {
      test('should be equal when version and message are equal', () {
        final request1 = UpdateRequest(
          version: Version(1, 0, 0),
          message: 'Update available!',
        );
        final request2 = UpdateRequest(
          version: Version(1, 0, 0),
          message: 'Update available!',
        );
        final request3 = UpdateRequest(
          version: Version(2, 0, 0),
          message: 'Update available!',
        );

        expect(request1, equals(request1));
        expect(request1, equals(request2));
        expect(request1.hashCode, equals(request2.hashCode));
        expect(request1, isNot(equals(request3)));
      });
    });

    group('toString', () {
      test('should include version and message', () {
        final updateRequest = UpdateRequest(
          version: Version(1, 0, 0),
          message: 'Update available!',
        );
        expect(
          updateRequest.toString(),
          'UpdateRequest(version: 1.0.0, message: Update available!)',
        );
      });
    });
  });
}
