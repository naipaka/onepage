// Test files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:mockito/mockito.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/router/router.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:theme/theme.dart';

import '../golden/golden_test_helpers.mocks.dart';

const _banner = 'Some photos need to be recovered';
const _title = 'Recover Photos';

class _FakeLibrary extends Fake implements PhotoLibrary {
  new(this.access);

  final PhotoLibraryAccess access;

  @override
  Future<PhotoLibraryAccess> requestAccess() async => access;

  @override
  Future<bool> get supportsFolder async => true;
}

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  int libraryRuns = 0;

  @override
  Future<int> recoverFromLibrary({PhotoRecoveryProgress? onProgress}) async {
    libraryRuns++;
    return 0;
  }
}

void main() {
  group('HomePage photo recovery', () {
    late MockDbClient dbClient;
    late MockPrefsClient prefsClient;
    late MockHaptics haptics;
    late _FakeCommand command;
    late DiaryImage image;
    var dismissed = false;

    setUp(() {
      dismissed = false;
      dbClient = MockDbClient();
      prefsClient = MockPrefsClient();
      haptics = MockHaptics();
      command = _FakeCommand();
      final now = clock.now();
      final today = DateTime(now.year, now.month, now.day);
      image = DiaryImage(
        id: 1,
        diaryId: 1,
        photoId: 'photo',
        createdAt: now,
        updatedAt: now,
      );
      final entry = DiaryEntry(
        id: 1,
        content: 'diary',
        date: today,
        createdAt: now,
        updatedAt: now,
      );

      when(
        dbClient.getDiaries(from: anyNamed('from'), to: anyNamed('to')),
      ).thenAnswer(
        (_) async => [
          Diary(entry: entry, images: [image]),
        ],
      );
      when(
        dbClient.watchDiaryImageCount(),
      ).thenAnswer((_) => const Stream.empty());
      when(prefsClient.textInputHapticEnabled).thenReturn(false);
      when(prefsClient.otherHapticEnabled).thenReturn(false);
      when(prefsClient.photoRecoveryDismissed).thenAnswer((_) => dismissed);
    });

    Future<void> pumpHome(
      WidgetTester tester, {
      PhotoLibraryAccess access = PhotoLibraryAccess.denied,
    }) async {
      LocaleSettings.setLocaleRawSync('en');
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final router = GoRouter(routes: $appRoutes);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dbClientProvider.overrideWithValue(dbClient),
            prefsClientProvider.overrideWithValue(prefsClient),
            hapticsProvider.overrideWithValue(haptics),
            trackerProvider.overrideWithValue(MockTracker()),
            inAppReviewerProvider.overrideWith(
              (ref) async => MockInAppReviewer(),
            ),
            photoLibraryProvider.overrideWithValue(_FakeLibrary(access)),
            photoRecoveryCommandProvider.overrideWithValue(command),
            photoStorageProvider.overrideWithValue(
              PhotoStorage(directory: Directory.systemTemp),
            ),
          ],
          child: TranslationProvider(
            child: MaterialApp.router(
              theme: appLightThemeData,
              localizationsDelegates: localizationsDelegates,
              supportedLocales: AppLocaleUtils.supportedLocales,
              locale: const Locale('en'),
              routerConfig: router,
            ),
          ),
        ),
      );
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    void stubUnmigrated(List<DiaryImage> images) {
      when(
        dbClient.getUnmigratedDiaryImages(),
      ).thenAnswer((_) async => images);
    }

    Future<void> openDrawer(WidgetTester tester) async {
      tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
      await tester.pumpAndSettle();
    }

    testWidgets('banner opens the recovery page', (tester) async {
      stubUnmigrated([image]);
      await pumpHome(tester);

      await tester.tap(find.text(_banner));
      await tester.pumpAndSettle();

      expect(find.text(_title), findsOneWidget);
      expect(find.text('Delete This Photo'), findsNothing);
    });

    testWidgets('hides the banner after the user declines', (tester) async {
      dismissed = true;
      stubUnmigrated([image]);
      await pumpHome(tester);

      expect(find.text(_banner), findsNothing);
    });

    testWidgets('imports photos when the library is readable', (tester) async {
      stubUnmigrated([image]);
      await pumpHome(tester, access: PhotoLibraryAccess.full);

      expect(command.libraryRuns, 1);
    });

    testWidgets('does not import without unmigrated photos', (tester) async {
      stubUnmigrated([]);
      await pumpHome(tester, access: PhotoLibraryAccess.full);

      expect(command.libraryRuns, 0);
      expect(find.text(_banner), findsNothing);
    });

    testWidgets('placeholder opens the page for its photo', (tester) async {
      stubUnmigrated([image]);
      await pumpHome(tester);

      await tester.tap(find.byType(PhotoPlaceholder));
      await tester.pumpAndSettle();

      expect(find.text('Delete This Photo'), findsOneWidget);
    });

    testWidgets('drawer opens the recovery page', (tester) async {
      stubUnmigrated([image]);
      await pumpHome(tester);

      await openDrawer(tester);
      await tester.tap(find.text(_title));
      await tester.pumpAndSettle();

      expect(find.text('Delete This Photo'), findsNothing);
      expect(find.text('Photos left to recover: 1'), findsOneWidget);
    });

    testWidgets('drawer hides the entry without unmigrated photos', (
      tester,
    ) async {
      stubUnmigrated([]);
      await pumpHome(tester);

      await openDrawer(tester);

      expect(find.text(_title), findsNothing);
    });
  });
}
