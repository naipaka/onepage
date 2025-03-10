import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const channel = MethodChannel('dev.fluttercommunity.plus/package_info');

void setUpMockPackageInfo() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
        if (methodCall.method == 'getAll') {
          return {
            'appName': 'Mock App',
            'packageName': 'com.example.mock',
            'version': '1.0.0',
            'buildNumber': '1',
            'buildSignature': 'mockSignature',
            'installerStore': 'mockInstallerStore',
          };
        }
        throw PlatformException(
          code: 'Unimplemented',
          details: 'The $methodCall method has not been implemented.',
        );
      });
}

void tearDownMockPackageInfo() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
}
