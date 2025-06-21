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
  Haptics({required PrefsClient prefsClient}) : _prefsClient = prefsClient;

  final PrefsClient _prefsClient;

  /// Triggers haptic feedback for text input interactions.
  ///
  /// Uses light impact feedback if text input haptic feedback is enabled.
  void textInputFeedback() {
    if (_prefsClient.textInputHapticEnabled) {
      HapticFeedback.lightImpact().ignore();
    }
  }

  /// Triggers haptic feedback for button tap interactions.
  ///
  /// Uses light impact feedback if other haptic feedback is enabled.
  void buttonTapFeedback() {
    if (_prefsClient.otherHapticEnabled) {
      HapticFeedback.lightImpact().ignore();
    }
  }

  /// Triggers haptic feedback for toggle/switch interactions.
  ///
  /// Uses selection click feedback if other haptic feedback is enabled.
  void toggleFeedback() {
    if (_prefsClient.otherHapticEnabled) {
      HapticFeedback.selectionClick().ignore();
    }
  }

  /// Triggers haptic feedback for navigation interactions.
  ///
  /// Uses light impact feedback if other haptic feedback is enabled.
  void navigationFeedback() {
    if (_prefsClient.otherHapticEnabled) {
      HapticFeedback.lightImpact().ignore();
    }
  }

  /// Triggers haptic feedback for successful actions.
  ///
  /// Uses double medium impact feedback (short pause between) if other haptic
  /// feedback is enabled.
  void successFeedback() {
    if (_prefsClient.otherHapticEnabled) {
      HapticFeedback.mediumImpact().ignore();
      // Short delay for double tap effect
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.mediumImpact().ignore();
      }).ignore();
    }
  }
}
