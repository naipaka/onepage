import 'package:flutter/foundation.dart';

/// Extension methods for [TargetPlatform].
extension TargetPlatformEx on TargetPlatform {
  /// Returns `true` if the platform is Android.
  bool get isAndroid => this == TargetPlatform.android;

  /// Returns `true` if the platform is iOS.
  bool get isIOS => this == TargetPlatform.iOS;

  /// Returns `true` if the platform is macOS.
  bool get isMacOS => this == TargetPlatform.macOS;

  /// Returns `true` if the platform is Windows.
  bool get isWindows => this == TargetPlatform.windows;

  /// Returns `true` if the platform is Linux.
  bool get isLinux => this == TargetPlatform.linux;

  /// Returns `true` if the platform is Fuchsia.
  bool get isFuchsia => this == TargetPlatform.fuchsia;
}
