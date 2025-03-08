import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const channel = MethodChannel('plugins.flutter.io/path_provider');

void setUpMockPathProvider() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
    if (methodCall.method == 'getTemporaryDirectory') {
      return '/tmp';
    }
    throw PlatformException(
      code: 'Unimplemented',
      details: 'The $methodCall method has not been implemented.',
    );
  });
}

void tearDownMockPathProvider() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
}
