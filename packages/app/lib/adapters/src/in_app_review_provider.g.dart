// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'in_app_review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isEligibleForInAppReviewHash() =>
    r'34d31de858bee2a5bd5835ea5ffc2d697c53609f';

/// Provider for in-app review eligibility.
///
/// This provider checks if the user is eligible for review prompts based on
/// diary activity. Returns true if the user has written content on at least
/// 3 different days in the past 6 months.
///
/// Copied from [isEligibleForInAppReview].
@ProviderFor(isEligibleForInAppReview)
final isEligibleForInAppReviewProvider =
    AutoDisposeFutureProvider<bool>.internal(
      isEligibleForInAppReview,
      name: r'isEligibleForInAppReviewProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$isEligibleForInAppReviewHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsEligibleForInAppReviewRef = AutoDisposeFutureProviderRef<bool>;
String _$inAppReviewerHash() => r'b9358e1e69a2ed80eaa62e0fc31df13f6201fae9';

/// Provider for the in-app review prompt functionality.
///
/// This provider creates an InAppReviewer instance with the required
/// dependencies (eligibility status and PrefsClient) injected.
///
/// Copied from [inAppReviewer].
@ProviderFor(inAppReviewer)
final inAppReviewerProvider = AutoDisposeFutureProvider<InAppReviewer>.internal(
  inAppReviewer,
  name: r'inAppReviewerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inAppReviewerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InAppReviewerRef = AutoDisposeFutureProviderRef<InAppReviewer>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
