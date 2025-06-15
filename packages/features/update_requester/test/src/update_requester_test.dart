import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:update_requester/src/models/models.dart';
import 'package:update_requester/src/update_requester.dart';
import 'package:version/version.dart';

import '../util/mock.mocks.dart';

void main() {
  group('UpdateRequester', () {
    group('updateRequestDefaultValue', () {
      test('should have correct default value', () {
        final expectedValue = jsonEncode(
          UpdateRequest(
            version: Version(1, 0, 0),
            message: '',
          ).toJson(),
        );
        expect(updateRequestDefaultValue, expectedValue);
      });
    });

    group('getConfig', () {
      test('should fetch UpdateRequest configuration', () {
        final configurator = MockConfigurator();
        final packageInfo = MockPackageInfo();
        final updateRequester = UpdateRequester(
          configurator: configurator,
          packageInfo: packageInfo,
        );

        void onConfigUpdated(UpdateRequest updateRequest) {}
        updateRequester.getConfig(onConfigUpdated: onConfigUpdated);

        verify(
          configurator.getDataConfig(
            updateRequestKey,
            fromJson: UpdateRequest.fromJson,
            onConfigUpdated: onConfigUpdated,
          ),
        ).called(1);
      });
    });

    group('updateRequestMessage', () {
      test('should return update message if current version is less than '
          'required version', () {
        final configurator = MockConfigurator();
        final packageInfo = MockPackageInfo();
        when(packageInfo.version).thenReturn('0.9.0');
        final updateRequester = UpdateRequester(
          configurator: configurator,
          packageInfo: packageInfo,
        );

        final updateRequest = UpdateRequest(
          version: Version(1, 0, 0),
          message: 'Update required!',
        );

        final message = updateRequester.updateRequestMessage(updateRequest);
        expect(message, 'Update required!');
      });

      test('should return null if current version is greater than or equal to '
          'required version', () {
        final configurator = MockConfigurator();
        final packageInfo = MockPackageInfo();
        when(packageInfo.version).thenReturn('1.0.0');
        final updateRequester = UpdateRequester(
          configurator: configurator,
          packageInfo: packageInfo,
        );

        final updateRequest = UpdateRequest(
          version: Version(1, 0, 0),
          message: 'Update required!',
        );

        final message = updateRequester.updateRequestMessage(updateRequest);
        expect(message, isNull);
      });
    });
  });
}
