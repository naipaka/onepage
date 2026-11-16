import 'dart:async';
import 'dart:convert';

import 'package:configurator/configurator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
      test('reads the update request and its updates', () async {
        final remoteConfig = MockFirebaseRemoteConfig();
        final updates = StreamController<RemoteConfigUpdate>();
        addTearDown(updates.close);
        var stored = UpdateRequest(version: Version(1, 2, 0), message: 'old');
        when(
          () => remoteConfig.getString(updateRequestKey),
        ).thenAnswer((_) => jsonEncode(stored.toJson()));
        when(
          () => remoteConfig.onConfigUpdated,
        ).thenAnswer((_) => updates.stream);
        when(remoteConfig.activate).thenAnswer((_) async => true);
        final updateRequester = UpdateRequester(
          configurator: Configurator.forTesting(remoteConfig),
          packageInfo: packageInfo('1.0.0'),
        );
        final received = <UpdateRequest>[];

        final config = updateRequester.getConfig(onConfigUpdated: received.add);
        addTearDown(config.dispose);
        stored = UpdateRequest(version: Version(2, 0, 0), message: 'new');
        updates.add(RemoteConfigUpdate({updateRequestKey}));
        await pumpEventQueue();

        expect(
          config.value,
          UpdateRequest(version: Version(1, 2, 0), message: 'old'),
        );
        expect(received, [
          UpdateRequest(version: Version(2, 0, 0), message: 'new'),
        ]);
      });
    });

    group('updateRequestMessage', () {
      test('should return update message if current version is less than '
          'required version', () {
        final updateRequester = UpdateRequester(
          configurator: Configurator.forTesting(MockFirebaseRemoteConfig()),
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
          configurator: Configurator.forTesting(MockFirebaseRemoteConfig()),
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
