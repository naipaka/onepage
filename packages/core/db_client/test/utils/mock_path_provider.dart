import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const channel = MethodChannel('plugins.flutter.io/path_provider');

void setUpMockPathProvider({
  String tempDir = '/tmp',
  String appSupportDir = '/app_support',
  String appDocDir = '/app_doc',
}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
    switch (methodCall.method) {
      case 'getTemporaryDirectory':
        return tempDir;
      case 'getApplicationSupportDirectory':
        return appSupportDir;
      case 'getApplicationDocumentsDirectory':
        return appDocDir;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'The ${methodCall.method} method has not been implemented.',
        );
    }
  });
}

void tearDownMockPathProvider() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
}
