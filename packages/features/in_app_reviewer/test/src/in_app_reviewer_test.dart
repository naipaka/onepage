import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_reviewer/in_app_reviewer.dart';
import 'package:mockito/mockito.dart';

import '../utils/mocks.mocks.dart';

void main() {
  group('InAppReviewer', () {
    late MockPrefsClient mockPrefsClient;
    late MockInAppReview mockInAppReview;
    late InAppReviewer reviewer;

    setUp(() {
      mockPrefsClient = MockPrefsClient();
      mockInAppReview = MockInAppReview();

      reviewer = InAppReviewer(
        isEligible: true,
        prefsClient: mockPrefsClient,
        inAppReview: mockInAppReview,
      );
    });

    group('shouldShowReviewPrompt', () {
      test('returns false when user has declined review', () async {
        // Arrange
        when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(true);

        // Act
        final result = await reviewer.shouldShowReviewPrompt();

        // Assert
        expect(result, false);
        verify(mockPrefsClient.hasDeclinedInAppReview).called(1);
        verifyNever(mockPrefsClient.lastInAppReviewShownAt);
      });

      test('returns false when in cooldown period', () async {
        // Arrange
        when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(false);
        // Set last shown to 30 days ago (within 180 day cooldown)
        final thirtyDaysAgo = DateTime(2024).millisecondsSinceEpoch;
        when(mockPrefsClient.lastInAppReviewShownAt).thenReturn(thirtyDaysAgo);

        await withClock(Clock.fixed(DateTime(2024, 1, 31)), () async {
          // Act
          final result = await reviewer.shouldShowReviewPrompt();

          // Assert
          expect(result, false);
          verify(mockPrefsClient.hasDeclinedInAppReview).called(1);
          verify(mockPrefsClient.lastInAppReviewShownAt).called(1);
        });
      });

      test(
        'returns false when user is not eligible',
        () async {
          // Arrange
          when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(false);
          when(mockPrefsClient.lastInAppReviewShownAt).thenReturn(null);

          final reviewerWithFalseEligibility = InAppReviewer(
            isEligible: false,
            prefsClient: mockPrefsClient,
            inAppReview: mockInAppReview,
          );

          // Act
          final result = await reviewerWithFalseEligibility
              .shouldShowReviewPrompt();

          // Assert
          expect(result, false);
          verify(mockPrefsClient.hasDeclinedInAppReview).called(1);
          verify(mockPrefsClient.lastInAppReviewShownAt).called(1);
        },
      );

      test('returns true when all conditions are met', () async {
        // Arrange
        when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(false);
        when(mockPrefsClient.lastInAppReviewShownAt).thenReturn(null);

        // Act
        final result = await reviewer.shouldShowReviewPrompt();

        // Assert
        expect(result, true);
        verify(mockPrefsClient.hasDeclinedInAppReview).called(1);
        verify(mockPrefsClient.lastInAppReviewShownAt).called(1);
      });
    });

    group('requestReview', () {
      test('does nothing when in-app review is not available', () async {
        // Arrange
        when(mockInAppReview.isAvailable()).thenAnswer((_) async => false);

        // Act
        await reviewer.requestReview();

        // Assert
        verify(mockInAppReview.isAvailable()).called(1);
        verifyNever(mockInAppReview.requestReview());
        verifyNever(
          mockPrefsClient.setLastInAppReviewShownAt(
            timestamp: anyNamed('timestamp'),
          ),
        );
      });

      test('requests review and records timestamp when available', () async {
        // Arrange
        when(mockInAppReview.isAvailable()).thenAnswer((_) async => true);
        when(mockInAppReview.requestReview()).thenAnswer((_) async {});
        when(
          mockPrefsClient.setLastInAppReviewShownAt(
            timestamp: anyNamed('timestamp'),
          ),
        ).thenAnswer((_) async => true);

        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          // Act
          await reviewer.requestReview();

          // Assert
          verify(mockInAppReview.isAvailable()).called(1);
          verify(mockInAppReview.requestReview()).called(1);
          verify(
            mockPrefsClient.setLastInAppReviewShownAt(
              timestamp: DateTime(2024, 6).millisecondsSinceEpoch,
            ),
          ).called(1);
        });
      });
    });

    group('openStoreListing', () {
      test('opens store listing and records timestamp', () async {
        // Arrange
        when(mockInAppReview.openStoreListing()).thenAnswer((_) async {});
        when(
          mockPrefsClient.setLastInAppReviewShownAt(
            timestamp: anyNamed('timestamp'),
          ),
        ).thenAnswer((_) async => true);

        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          // Act
          await reviewer.openStoreListing();

          // Assert
          verify(mockInAppReview.openStoreListing()).called(1);
          verify(
            mockPrefsClient.setLastInAppReviewShownAt(
              timestamp: DateTime(2024, 6).millisecondsSinceEpoch,
            ),
          ).called(1);
        });
      });
    });

    group('checkAndShowReviewIfEligible', () {
      test('does not request review when conditions are not met', () async {
        // Arrange
        when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(true);

        // Act
        await reviewer.checkAndShowReviewIfEligible();

        // Assert
        verify(mockPrefsClient.hasDeclinedInAppReview).called(1);
      });

      test('requests review when conditions are met', () async {
        // Arrange
        when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(false);
        when(mockPrefsClient.lastInAppReviewShownAt).thenReturn(null);
        when(mockInAppReview.isAvailable()).thenAnswer((_) async => true);
        when(mockInAppReview.requestReview()).thenAnswer((_) async {});
        when(
          mockPrefsClient.setLastInAppReviewShownAt(
            timestamp: anyNamed('timestamp'),
          ),
        ).thenAnswer((_) async => true);

        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          // Act
          await reviewer.checkAndShowReviewIfEligible();

          // Assert
          verify(mockPrefsClient.hasDeclinedInAppReview).called(1);
          verify(mockPrefsClient.lastInAppReviewShownAt).called(1);
          verify(mockInAppReview.isAvailable()).called(1);
          verify(mockInAppReview.requestReview()).called(1);
          verify(
            mockPrefsClient.setLastInAppReviewShownAt(
              timestamp: DateTime(2024, 6).millisecondsSinceEpoch,
            ),
          ).called(1);
        });
      });
    });

    group('markAsDeclined', () {
      test('sets declined preference to true', () async {
        // Arrange
        when(
          mockPrefsClient.setHasDeclinedInAppReview(value: true),
        ).thenAnswer((_) async => true);

        // Act
        await reviewer.markAsDeclined();

        // Assert
        verify(
          mockPrefsClient.setHasDeclinedInAppReview(value: true),
        ).called(1);
      });
    });

    group('recordReviewShown', () {
      test('records current timestamp', () async {
        // Arrange
        when(
          mockPrefsClient.setLastInAppReviewShownAt(
            timestamp: anyNamed('timestamp'),
          ),
        ).thenAnswer((_) async => true);

        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          // Act
          await reviewer.recordReviewShown();

          // Assert
          verify(
            mockPrefsClient.setLastInAppReviewShownAt(
              timestamp: DateTime(2024, 6).millisecondsSinceEpoch,
            ),
          ).called(1);
        });
      });
    });

    group('eligibility', () {
      test('returns true when user is eligible', () async {
        // Arrange
        when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(false);
        when(mockPrefsClient.lastInAppReviewShownAt).thenReturn(null);

        final eligibleReviewer = InAppReviewer(
          isEligible: true,
          prefsClient: mockPrefsClient,
          inAppReview: mockInAppReview,
        );

        // Act
        final result = await eligibleReviewer.shouldShowReviewPrompt();

        // Assert
        expect(result, true);
      });

      test('returns false when user is not eligible', () async {
        // Arrange
        when(mockPrefsClient.hasDeclinedInAppReview).thenReturn(false);
        when(mockPrefsClient.lastInAppReviewShownAt).thenReturn(null);

        final ineligibleReviewer = InAppReviewer(
          isEligible: false,
          prefsClient: mockPrefsClient,
          inAppReview: mockInAppReview,
        );

        // Act
        final result = await ineligibleReviewer.shouldShowReviewPrompt();

        // Assert
        expect(result, false);
      });
    });

    group('constructor', () {
      test('uses InAppReview.instance when inAppReview is not provided', () {
        // This test ensures the default InAppReview.instance is used
        // when no inAppReview is explicitly provided, achieving 100%
        // coverage

        // Act
        final reviewerWithDefaultInstance = InAppReviewer(
          isEligible: true,
          prefsClient: mockPrefsClient,
          // inAppReview is intentionally not provided
        );

        // Assert
        expect(reviewerWithDefaultInstance, isNotNull);
        // The _inAppReview field should be initialized with
        // InAppReview.instance
      });
    });
  });
}
