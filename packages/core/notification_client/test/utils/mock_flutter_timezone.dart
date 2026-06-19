import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const channel = MethodChannel('flutter_timezone');

final methodCallLog = <MethodCall>[];

void setupMockFlutterTimezone() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
        methodCallLog.add(methodCall);
        switch (methodCall.method) {
          case 'getLocalTimezone':
            return 'Etc/UTC';
          default:
            return null;
        }
      });
}

void tearDownMockFlutterTimezone() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
  methodCallLog.clear();
}
