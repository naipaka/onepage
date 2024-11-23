import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'platform_provider.g.dart';

/// Provide the current [TargetPlatform].
@Riverpod(keepAlive: true)
TargetPlatform platform(Ref ref) {
  return defaultTargetPlatform;
}

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
