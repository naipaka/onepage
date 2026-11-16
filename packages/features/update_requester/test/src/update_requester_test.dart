import 'dart:convert';

import 'package:configurator/configurator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:update_requester/src/models/models.dart';
import 'package:update_requester/src/update_requester.dart';
import 'package:version/version.dart';

import '../util/mock.dart';

void main() {
  PackageInfo packageInfo(String version) => PackageInfo(
    appName: 'One Page',
    packageName: 'jp.co.altive.onepage',
    version: version,
    buildNumber: '1',
  );

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
      test('returns the update request config of the configurator', () {
        final configurator = MockConfigurator();
        final config = Config(
          value: UpdateRequest(version: Version(1, 0, 0), message: ''),
          subscription: null,
        );
        void onConfigUpdated(UpdateRequest updateRequest) {}
        when(
          () => configurator.getDataConfig(
            updateRequestKey,
            fromJson: UpdateRequest.fromJson,
            onConfigUpdated: onConfigUpdated,
          ),
        ).thenReturn(config);
        final updateRequester = UpdateRequester(
          configurator: configurator,
          packageInfo: packageInfo('1.0.0'),
        );

        expect(
          updateRequester.getConfig(onConfigUpdated: onConfigUpdated),
          config,
        );
      });
    });

    group('updateRequestMessage', () {
      test('should return update message if current version is less than '
          'required version', () {
        final updateRequester = UpdateRequester(
          configurator: MockConfigurator(),
          packageInfo: packageInfo('0.9.0'),
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
        final updateRequester = UpdateRequester(
          configurator: MockConfigurator(),
          packageInfo: packageInfo('1.0.0'),
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
