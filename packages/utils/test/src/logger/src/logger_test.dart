import 'package:flutter/foundation.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:test/test.dart';
import 'package:utils/src/logger/src/logger.dart';

void main() {
  group('Logger', () {
    test('Logger is initialized with correct level', () {
      expect(logger.level, Level.FINEST);
    });

    test('Logger includes caller info in debug mode', () {
      expect(logger.includeCallerInfo, kDebugMode);
    });

    test('Logger can log messages', () {
      expect(() => logger.info('Test message'), returnsNormally);
    });

    test('Logger can log errors', () {
      expect(() => logger.severe('Test error'), returnsNormally);
    });
  });
}
