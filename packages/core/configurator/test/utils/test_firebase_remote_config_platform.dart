import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';

class TestFirebaseRemoteConfigPlatform extends FirebaseRemoteConfigPlatform {
  new() : super();

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
