import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const channel = MethodChannel('plugins.flutter.io/path_provider');

/// Makes path_provider return [temporaryPath] and [supportPath].
void setUpMockPathProvider({
  required String temporaryPath,
  required String supportPath,
}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
        switch (methodCall.method) {
          case 'getTemporaryDirectory':
            return temporaryPath;
          case 'getApplicationSupportDirectory':
            return supportPath;
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
