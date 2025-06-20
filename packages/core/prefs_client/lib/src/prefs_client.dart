import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'prefs_key.dart';

/// {@template prefs_client.PrefsClient}
/// A wrapper around SharedPreferences that provides type-safe access to
/// application preferences.
///
/// This class centralizes preference management and provides methods for
/// getting and setting specific preference values with proper type safety.
/// {@endtemplate}
class PrefsClient {
  /// {@macro prefs_client.PrefsClient}
  ///
  /// This constructor is private to prevent external instantiation.
  /// Use [PrefsClient.initialize] to create instances.
  PrefsClient._(this._prefs);

  /// {@macro prefs_client.PrefsClient}
  ///
  /// This constructor allows for dependency injection in tests.
  @visibleForTesting
  PrefsClient.forTesting(this._prefs);

  final SharedPreferences _prefs;

  /// Creates and initializes a [PrefsClient] instance.
  ///
  /// This method should be called once during app initialization to create
  /// the singleton instance that will be injected throughout the app.
  static Future<PrefsClient> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsClient._(prefs);
  }

  /// Gets whether text input haptic feedback is enabled.
  ///
  /// Returns `false` by default if no value has been set.
  bool get textInputHapticEnabled =>
      _prefs.getBool(PrefsKey.textInputHaptic.name) ?? false;

  /// Sets whether text input haptic feedback is enabled.
  Future<bool> setTextInputHapticEnabled({required bool enabled}) =>
      _prefs.setBool(PrefsKey.textInputHaptic.name, enabled);

  /// Gets whether other haptic feedback (icon taps, etc.) is enabled.
  ///
  /// Returns `false` by default if no value has been set.
  bool get otherHapticEnabled =>
      _prefs.getBool(PrefsKey.otherHaptic.name) ?? false;

  /// Sets whether other haptic feedback is enabled.
  Future<bool> setOtherHapticEnabled({required bool enabled}) =>
      _prefs.setBool(PrefsKey.otherHaptic.name, enabled);
}
