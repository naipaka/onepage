import 'package:clock/clock.dart';
import 'package:in_app_reviewer/in_app_reviewer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'diary_provider.dart';
import 'prefs_client_provider.dart';

part 'in_app_review_provider.g.dart';

/// Provider for in-app review eligibility.
///
/// This provider checks if the user is eligible for review prompts based on
/// diary activity. Returns true if the user has written content on at least
/// 3 different days in the past 6 months.
@riverpod
Future<bool> isEligibleForInAppReview(Ref ref) async {
  final diaryQuery = ref.watch(diaryQueryProvider);

  const requiredDaysWithEntries = 3;
  const monthsToCheck = 6;

  final now = clock.now();
  final startDate = DateTime(
    now.year,
    now.month - monthsToCheck,
    now.day,
  );

  final count = await diaryQuery.countUniqueDaysWithContentInRange(
    from: startDate,
    to: now,
  );

  return count >= requiredDaysWithEntries;
}

/// Provider for the in-app review prompt functionality.
///
/// This provider creates an InAppReviewer instance with the required
/// dependencies (eligibility status and PrefsClient) injected.
@riverpod
Future<InAppReviewer> inAppReviewer(Ref ref) async {
  final isEligible = await ref.watch(isEligibleForInAppReviewProvider.future);
  final prefsClient = ref.watch(prefsClientProvider);
  
  return InAppReviewer(
    isEligible: isEligible,
    prefsClient: prefsClient,
  );
}
