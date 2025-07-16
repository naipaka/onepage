import 'dart:async';

import 'package:clock/clock.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:prefs_client/prefs_client.dart';

/// In-app review manager that handles prompting users for app store reviews.
///
/// This class manages the logic for determining when to show review prompts
/// based on user activity and preferences. It integrates with the in_app_review
/// package to show native review dialogs.
class InAppReviewer {
  /// Creates an [InAppReviewer] with required dependencies.
  ///
  /// The [isEligible] indicates whether the user is eligible for review
  /// prompts. The [prefsClient] manages user preferences and review history.
  /// The [inAppReview] allows for dependency injection in tests.
  /// The [reviewCooldownPeriod] defines how long to wait between review
  /// prompts.
  InAppReviewer({
    required bool isEligible,
    required PrefsClient prefsClient,
    InAppReview? inAppReview,
    Duration reviewCooldownPeriod = const Duration(days: 180),
  }) : _isEligible = isEligible,
       _prefsClient = prefsClient,
       _inAppReview = inAppReview ?? InAppReview.instance,
       _reviewCooldownPeriod = reviewCooldownPeriod;

  final bool _isEligible;
  final PrefsClient _prefsClient;
  final InAppReview _inAppReview;
  final Duration _reviewCooldownPeriod;

  /// Determines if the review prompt should be shown to the user.
  ///
  /// Returns `true` if all conditions are met:
  /// - User hasn't declined review previously
  /// - Not in cooldown period
  /// - User is eligible for review prompts
  Future<bool> shouldShowReviewPrompt() async {
    if (await _hasDeclinedReview()) {
      return false;
    }

    if (await _isInCooldownPeriod()) {
      return false;
    }

    return _isEligible;
  }

  /// Requests a review from the user using the native review dialog.
  ///
  /// This method checks if in-app review is available and shows the
  /// system review prompt if possible. Records the timestamp when shown.
  Future<void> requestReview() async {
    final isAvailable = await _inAppReview.isAvailable();
    if (!isAvailable) {
      return;
    }

    await _inAppReview.requestReview();
    await _recordReviewShown();
  }

  /// Opens the app store listing page for the app.
  ///
  /// This provides an alternative way for users to leave reviews
  /// when the in-app review dialog isn't available.
  Future<void> openStoreListing() async {
    await _inAppReview.openStoreListing();
    await _recordReviewShown();
  }

  /// Checks eligibility and automatically shows review prompt if conditions
  /// are met.
  ///
  /// This is a convenience method that combines [shouldShowReviewPrompt]
  /// and [requestReview] in a single call.
  Future<void> checkAndShowReviewIfEligible() async {
    final shouldShow = await shouldShowReviewPrompt();
    if (shouldShow) {
      await requestReview();
    }
  }

  /// Marks that the user has declined to provide a review.
  ///
  /// This prevents future review prompts from being shown to the user.
  Future<void> markAsDeclined() async {
    await _prefsClient.setHasDeclinedInAppReview(value: true);
  }

  /// Records that a review prompt was shown to the user.
  ///
  /// This updates the timestamp used for cooldown period calculations.
  Future<void> recordReviewShown() async {
    await _recordReviewShown();
  }

  Future<bool> _hasDeclinedReview() async {
    return _prefsClient.hasDeclinedInAppReview;
  }

  Future<bool> _isInCooldownPeriod() async {
    final lastShownTimestamp = _prefsClient.lastInAppReviewShownAt;

    if (lastShownTimestamp == null) {
      return false;
    }

    final lastShownDate = DateTime.fromMillisecondsSinceEpoch(
      lastShownTimestamp,
    );
    final now = clock.now();

    return now.difference(lastShownDate) < _reviewCooldownPeriod;
  }

  Future<void> _recordReviewShown() async {
    final timestamp = clock.now().millisecondsSinceEpoch;
    await _prefsClient.setLastInAppReviewShownAt(timestamp: timestamp);
  }
}
