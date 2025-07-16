/// {@template prefs_client.PrefsKey}
/// Enumeration of all preference keys used in the application.
///
/// This enum provides type-safe access to preference keys and centralizes
/// key management to prevent typos and conflicts.
///
/// When a preference key is no longer needed, mark the enum value with
/// @[Deprecated] annotation instead of removing it immediately. This prevents
/// breaking changes and allows for proper migration handling.
/// {@endtemplate}
enum PrefsKey {
  /// Whether text input haptic feedback is enabled.
  textInputHaptic,

  /// Whether other haptic feedback (icon taps, etc.) is enabled.
  otherHaptic,

  /// Notification settings stored as JSON string.
  notificationSettings,

  /// Timestamp of the last time the in-app review was shown.
  lastInAppReviewShownAt,

  /// Whether the user has already been asked for review and declined.
  hasDeclinedInAppReview,
}
