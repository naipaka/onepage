import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const channel = MethodChannel('dev.fluttercommunity.plus/share');

void setUpMockShare() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
    if (methodCall.method == 'shareFiles') {
      return 'true';
    }
    return null;
  });
}

void tearDownMockShare() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
}
