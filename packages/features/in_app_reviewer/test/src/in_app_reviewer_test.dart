import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_reviewer/in_app_reviewer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/mock.dart';

void main() {
  group('InAppReviewer', () {
    late PrefsClient prefsClient;
    late MockInAppReview mockInAppReview;

    Future<void> setUpPrefs(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      prefsClient = await PrefsClient.initialize();
    }

    InAppReviewer createReviewer({bool isEligible = true}) {
      return InAppReviewer(
        isEligible: isEligible,
        prefsClient: prefsClient,
        inAppReview: mockInAppReview,
      );
    }

    setUp(() async {
      await setUpPrefs({});
      mockInAppReview = MockInAppReview();
    });

    group('shouldShowReviewPrompt', () {
      test('returns false when user has declined review', () async {
        await setUpPrefs({'hasDeclinedInAppReview': true});

        expect(await createReviewer().shouldShowReviewPrompt(), isFalse);
      });

      test('returns false when in cooldown period', () async {
        await setUpPrefs({
          'lastInAppReviewShownAt': DateTime(2024).millisecondsSinceEpoch,
        });

        await withClock(Clock.fixed(DateTime(2024, 1, 31)), () async {
          expect(await createReviewer().shouldShowReviewPrompt(), isFalse);
        });
      });

      test('returns true after the cooldown period', () async {
        await setUpPrefs({
          'lastInAppReviewShownAt': DateTime(2024).millisecondsSinceEpoch,
        });

        await withClock(Clock.fixed(DateTime(2024, 7)), () async {
          expect(await createReviewer().shouldShowReviewPrompt(), isTrue);
        });
      });

      test('returns false when user is not eligible', () async {
        final reviewer = createReviewer(isEligible: false);

        expect(await reviewer.shouldShowReviewPrompt(), isFalse);
      });

      test('returns true when all conditions are met', () async {
        expect(await createReviewer().shouldShowReviewPrompt(), isTrue);
      });
    });

    group('requestReview', () {
      test('does nothing when in-app review is not available', () async {
        when(
          () => mockInAppReview.isAvailable(),
        ).thenAnswer((_) async => false);

        await createReviewer().requestReview();

        verifyNever(() => mockInAppReview.requestReview());
        expect(prefsClient.lastInAppReviewShownAt, isNull);
      });

      test('requests review and records timestamp when available', () async {
        when(() => mockInAppReview.isAvailable()).thenAnswer((_) async => true);
        when(() => mockInAppReview.requestReview()).thenAnswer((_) async {});

        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          await createReviewer().requestReview();
        });

        verify(() => mockInAppReview.requestReview()).called(1);
        expect(
          prefsClient.lastInAppReviewShownAt,
          DateTime(2024, 6).millisecondsSinceEpoch,
        );
      });
    });

    group('openStoreListing', () {
      test('opens store listing and records timestamp', () async {
        when(() => mockInAppReview.openStoreListing()).thenAnswer((_) async {});

        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          await createReviewer().openStoreListing();
        });

        verify(() => mockInAppReview.openStoreListing()).called(1);
        expect(
          prefsClient.lastInAppReviewShownAt,
          DateTime(2024, 6).millisecondsSinceEpoch,
        );
      });
    });

    group('checkAndShowReviewIfEligible', () {
      test('does not request review when conditions are not met', () async {
        await setUpPrefs({'hasDeclinedInAppReview': true});

        await createReviewer().checkAndShowReviewIfEligible();

        verifyNever(() => mockInAppReview.isAvailable());
        verifyNever(() => mockInAppReview.requestReview());
      });

      test('requests review when conditions are met', () async {
        when(() => mockInAppReview.isAvailable()).thenAnswer((_) async => true);
        when(() => mockInAppReview.requestReview()).thenAnswer((_) async {});

        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          await createReviewer().checkAndShowReviewIfEligible();
        });

        verify(() => mockInAppReview.requestReview()).called(1);
        expect(
          prefsClient.lastInAppReviewShownAt,
          DateTime(2024, 6).millisecondsSinceEpoch,
        );
      });
    });

    group('markAsDeclined', () {
      test('sets declined preference to true', () async {
        await createReviewer().markAsDeclined();

        expect(prefsClient.hasDeclinedInAppReview, isTrue);
      });
    });

    group('recordReviewShown', () {
      test('records current timestamp', () async {
        await withClock(Clock.fixed(DateTime(2024, 6)), () async {
          await createReviewer().recordReviewShown();
        });

        expect(
          prefsClient.lastInAppReviewShownAt,
          DateTime(2024, 6).millisecondsSinceEpoch,
        );
      });
    });

    group('constructor', () {
      test('uses InAppReview.instance when inAppReview is not provided', () {
        final reviewer = InAppReviewer(
          isEligible: true,
          prefsClient: prefsClient,
        );

        expect(reviewer, isNotNull);
      });
    });
  });
}
