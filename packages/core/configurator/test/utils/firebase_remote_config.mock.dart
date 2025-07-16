import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFirebaseRemoteConfigPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TestFirebaseRemoteConfigPlatform {
  MockFirebaseRemoteConfigPlatform() {
    TestFirebaseRemoteConfigPlatform();
  }

  @override
  FirebaseRemoteConfigPlatform delegateFor({FirebaseApp? app}) {
    return super.noSuchMethod(
          Invocation.method(#delegateFor, [], {#app: app}),
          returnValue: TestFirebaseRemoteConfigPlatform(),
          returnValueForMissingStub: TestFirebaseRemoteConfigPlatform(),
        )
        as FirebaseRemoteConfigPlatform;
  }

  @override
  FirebaseRemoteConfigPlatform setInitialValues({
    Map<dynamic, dynamic>? remoteConfigValues,
  }) {
    return super.noSuchMethod(
          Invocation.method(
            #setInitialValues,
            [],
            {#remoteConfigValues: remoteConfigValues},
          ),
          returnValue: TestFirebaseRemoteConfigPlatform(),
          returnValueForMissingStub: TestFirebaseRemoteConfigPlatform(),
        )
        as FirebaseRemoteConfigPlatform;
  }

  @override
  Future<bool> fetchAndActivate() {
    return super.noSuchMethod(
          Invocation.method(#fetchAndActivate, []),
          returnValue: Future<bool>.value(true),
          returnValueForMissingStub: Future<bool>.value(true),
        )
        as Future<bool>;
  }

  @override
  Future<void> setConfigSettings(RemoteConfigSettings? remoteConfigSettings) {
    return super.noSuchMethod(
          Invocation.method(#setConfigSettings, [remoteConfigSettings]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value(),
        )
        as Future<void>;
  }

  @override
  Future<void> setDefaults(Map<String, dynamic>? defaultParameters) {
    return super.noSuchMethod(
          Invocation.method(#setDefaults, [defaultParameters]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value(),
        )
        as Future<void>;
  }
}

class TestFirebaseRemoteConfigPlatform extends FirebaseRemoteConfigPlatform {
  TestFirebaseRemoteConfigPlatform() : super();

  @override
  FirebaseRemoteConfigPlatform delegateFor({FirebaseApp? app}) {
    return this;
  }

  @override
  FirebaseRemoteConfigPlatform setInitialValues({
    Map<dynamic, dynamic>? remoteConfigValues,
  }) {
    return this;
  }
}
