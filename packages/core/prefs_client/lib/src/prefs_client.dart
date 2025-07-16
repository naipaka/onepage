import 'dart:convert';

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

  /// Gets notification settings as a JSON list.
  ///
  /// Returns an empty list if no value has been saved or if decoding fails.
  List<Map<String, dynamic>> get notificationSettings {
    final jsonString = _prefs.getString(PrefsKey.notificationSettings.name);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.cast<Map<String, dynamic>>();
    } on Exception {
      return [];
    }
  }

  /// Saves notification settings as a JSON list.
  Future<bool> setNotificationSettings(List<Map<String, dynamic>> settings) {
    final jsonString = json.encode(settings);
    return _prefs.setString(PrefsKey.notificationSettings.name, jsonString);
  }

  /// Gets whether the user has declined in-app review.
  ///
  /// Returns `false` by default if no value has been set.
  bool get hasDeclinedInAppReview =>
      _prefs.getBool(PrefsKey.hasDeclinedInAppReview.name) ?? false;

  /// Sets whether the user has declined in-app review.
  Future<bool> setHasDeclinedInAppReview({required bool value}) =>
      _prefs.setBool(PrefsKey.hasDeclinedInAppReview.name, value);

  /// Gets the timestamp of the last time in-app review was shown.
  ///
  /// Returns null if no value has been set.
  int? get lastInAppReviewShownAt =>
      _prefs.getInt(PrefsKey.lastInAppReviewShownAt.name);

  /// Sets the timestamp of the last time in-app review was shown.
  Future<bool> setLastInAppReviewShownAt({required int timestamp}) =>
      _prefs.setInt(PrefsKey.lastInAppReviewShownAt.name, timestamp);
}
