// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'in_app_review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for in-app review eligibility.
///
/// This provider checks if the user is eligible for review prompts based on
/// diary activity. Returns true if the user has written content on at least
/// 3 different days in the past 6 months.

@ProviderFor(isEligibleForInAppReview)
const isEligibleForInAppReviewProvider = IsEligibleForInAppReviewProvider._();

/// Provider for in-app review eligibility.
///
/// This provider checks if the user is eligible for review prompts based on
/// diary activity. Returns true if the user has written content on at least
/// 3 different days in the past 6 months.

final class IsEligibleForInAppReviewProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for in-app review eligibility.
  ///
  /// This provider checks if the user is eligible for review prompts based on
  /// diary activity. Returns true if the user has written content on at least
  /// 3 different days in the past 6 months.
  const IsEligibleForInAppReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isEligibleForInAppReviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isEligibleForInAppReviewHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isEligibleForInAppReview(ref);
  }
}

String _$isEligibleForInAppReviewHash() =>
    r'34d31de858bee2a5bd5835ea5ffc2d697c53609f';

/// Provider for the in-app review prompt functionality.
///
/// This provider creates an InAppReviewer instance with the required
/// dependencies (eligibility status and PrefsClient) injected.

@ProviderFor(inAppReviewer)
const inAppReviewerProvider = InAppReviewerProvider._();

/// Provider for the in-app review prompt functionality.
///
/// This provider creates an InAppReviewer instance with the required
/// dependencies (eligibility status and PrefsClient) injected.

final class InAppReviewerProvider
    extends
        $FunctionalProvider<
          AsyncValue<InAppReviewer>,
          InAppReviewer,
          FutureOr<InAppReviewer>
        >
    with $FutureModifier<InAppReviewer>, $FutureProvider<InAppReviewer> {
  /// Provider for the in-app review prompt functionality.
  ///
  /// This provider creates an InAppReviewer instance with the required
  /// dependencies (eligibility status and PrefsClient) injected.
  const InAppReviewerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inAppReviewerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inAppReviewerHash();

  @$internal
  @override
  $FutureProviderElement<InAppReviewer> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InAppReviewer> create(Ref ref) {
    return inAppReviewer(ref);
  }
}

String _$inAppReviewerHash() => r'b9358e1e69a2ed80eaa62e0fc31df13f6201fae9';
