import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:utils/src/extension/src/target_platform_extension.dart';

void main() {
  group('TargetPlatformEx', () {
    test('isAndroid returns true for TargetPlatform.android', () {
      expect(TargetPlatform.android.isAndroid, isTrue);
    });

    test('isIOS returns true for TargetPlatform.iOS', () {
      expect(TargetPlatform.iOS.isIOS, isTrue);
    });

    test('isMacOS returns true for TargetPlatform.macOS', () {
      expect(TargetPlatform.macOS.isMacOS, isTrue);
    });

    test('isWindows returns true for TargetPlatform.windows', () {
      expect(TargetPlatform.windows.isWindows, isTrue);
    });

    test('isLinux returns true for TargetPlatform.linux', () {
      expect(TargetPlatform.linux.isLinux, isTrue);
    });

    test('isFuchsia returns true for TargetPlatform.fuchsia', () {
      expect(TargetPlatform.fuchsia.isFuchsia, isTrue);
    });

    test('isAndroid returns false for non-Android platforms', () {
      expect(TargetPlatform.iOS.isAndroid, isFalse);
      expect(TargetPlatform.macOS.isAndroid, isFalse);
      expect(TargetPlatform.windows.isAndroid, isFalse);
      expect(TargetPlatform.linux.isAndroid, isFalse);
      expect(TargetPlatform.fuchsia.isAndroid, isFalse);
    });

    test('isIOS returns false for non-iOS platforms', () {
      expect(TargetPlatform.android.isIOS, isFalse);
      expect(TargetPlatform.macOS.isIOS, isFalse);
      expect(TargetPlatform.windows.isIOS, isFalse);
      expect(TargetPlatform.linux.isIOS, isFalse);
      expect(TargetPlatform.fuchsia.isIOS, isFalse);
    });

    test('isMacOS returns false for non-macOS platforms', () {
      expect(TargetPlatform.android.isMacOS, isFalse);
      expect(TargetPlatform.iOS.isMacOS, isFalse);
      expect(TargetPlatform.windows.isMacOS, isFalse);
      expect(TargetPlatform.linux.isMacOS, isFalse);
      expect(TargetPlatform.fuchsia.isMacOS, isFalse);
    });

    test('isWindows returns false for non-Windows platforms', () {
      expect(TargetPlatform.android.isWindows, isFalse);
      expect(TargetPlatform.iOS.isWindows, isFalse);
      expect(TargetPlatform.macOS.isWindows, isFalse);
      expect(TargetPlatform.linux.isWindows, isFalse);
      expect(TargetPlatform.fuchsia.isWindows, isFalse);
    });

    test('isLinux returns false for non-Linux platforms', () {
      expect(TargetPlatform.android.isLinux, isFalse);
      expect(TargetPlatform.iOS.isLinux, isFalse);
      expect(TargetPlatform.macOS.isLinux, isFalse);
      expect(TargetPlatform.windows.isLinux, isFalse);
      expect(TargetPlatform.fuchsia.isLinux, isFalse);
    });

    test('isFuchsia returns false for non-Fuchsia platforms', () {
      expect(TargetPlatform.android.isFuchsia, isFalse);
      expect(TargetPlatform.iOS.isFuchsia, isFalse);
      expect(TargetPlatform.macOS.isFuchsia, isFalse);
      expect(TargetPlatform.windows.isFuchsia, isFalse);
      expect(TargetPlatform.linux.isFuchsia, isFalse);
    });
  });
}
