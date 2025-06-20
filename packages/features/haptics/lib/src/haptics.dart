import 'package:flutter/services.dart';
import 'package:prefs_client/prefs_client.dart';

/// {@template haptics.Haptics}
/// A service that provides haptic feedback functionality with preference-based
/// control.
///
/// This class wraps Flutter's haptic feedback APIs and adds preference
/// checking to enable or disable feedback based on user settings.
/// {@endtemplate}
class Haptics {
  /// {@macro haptics.Haptics}
  Haptics(this._prefsClient);

  final PrefsClient _prefsClient;

  /// Triggers haptic feedback for text input interactions.
  ///
  /// Uses light impact feedback if text input haptic feedback is enabled.
  Future<void> textInputFeedback() async {
    if (_prefsClient.textInputHapticEnabled) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Triggers haptic feedback for button tap interactions.
  ///
  /// Uses medium impact feedback if other haptic feedback is enabled.
  Future<void> buttonTapFeedback() async {
    if (_prefsClient.otherHapticEnabled) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Triggers haptic feedback for toggle/switch interactions.
  ///
  /// Uses selection click feedback if other haptic feedback is enabled.
  Future<void> toggleFeedback() async {
    if (_prefsClient.otherHapticEnabled) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Triggers haptic feedback for navigation interactions.
  ///
  /// Uses light impact feedback if other haptic feedback is enabled.
  Future<void> navigationFeedback() async {
    if (_prefsClient.otherHapticEnabled) {
      await HapticFeedback.lightImpact();
    }
  }

}
