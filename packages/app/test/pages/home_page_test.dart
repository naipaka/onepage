import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/keys.dart';
import 'package:onepage/router/router.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';

import '../utils/clients.dart';

const _title = 'Recover Photos';

class _FakeLibrary extends Fake implements DevicePhotos {
  new(this.option);

  final DevicePhotoAccessOption option;

  @override
  Future<DevicePhotoAccessOption> accessOption(List<String> ids) async =>
      option;
}

var _diariesFail = false;

class _FlakyDiaries extends CachedDiaries {
  @override
  Future<DiariesWithDates> build() {
    if (_diariesFail) {
      throw Exception('failed');
    }
    return super.build();
  }
}

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  Future<int> recovery = Future.syncValue(0);

  @override
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) {
    return recovery;
  }
}

void main() {
  group('HomePage', () {
    late DbClient dbClient;
    late PrefsClient prefsClient;
    late _FakeCommand command;

    Future<DbClient> createDbClientWithPhoto() async {
      final client = createDbClient();
      final now = clock.now();
      final diary = await client.insertDiary(
        content: 'diary',
        date: DateTime(now.year, now.month, now.day),
      );
      await insertExternalDiaryImage(
        client,
        diaryId: diary.id,
        photoId: 'photo',
      );
      return client;
    }

    setUp(() async {
      dbClient = await createDbClientWithPhoto();
      prefsClient = createPrefsClient();
      command = _FakeCommand();
    });

    Future<void> pumpHome(
      WidgetTester tester, {
      DevicePhotoAccessOption option = DevicePhotoAccessOption.requestPhotos,
      List<Override> overrides = const [],
    }) async {
      LocaleSettings.setLocaleRawSync('en');
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final router = GoRouter(routes: $appRoutes);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          retry: noRetry,
          overrides: [
            dbClientProvider.overrideWith((ref) => dbClient),
            prefsClientProvider.overrideWithValue(prefsClient),
            trackerProvider.overrideWithValue(createTracker()),
            inAppReviewerProvider.overrideWith(
              (ref) async => createInAppReviewer(),
            ),
            devicePhotosProvider.overrideWithValue(_FakeLibrary(option)),
            photoRecoveryCommandProvider.overrideWithValue(command),
            photoStorageProvider.overrideWithValue(
              PhotoStorage(directory: Directory.systemTemp),
            ),
            ...overrides,
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

    Future<void> openDrawer(WidgetTester tester) async {
      tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
      await tester.pumpAndSettle();
    }

    group('photo recovery', () {
      testWidgets('placeholder opens the page for its photo', (tester) async {
        await pumpHome(tester);

        await tester.tap(find.byType(PhotoThumbnail));
        await tester.pumpAndSettle();

        expect(find.text('Delete This Photo'), findsOneWidget);
      });

      testWidgets('placeholder shows progress while recovering', (
        tester,
      ) async {
        final recovery = Completer<int>();
        command.recovery = recovery.future;
        await pumpHome(tester);
        final thumbnail = find.byType(PhotoThumbnail);
        final container = ProviderScope.containerOf(tester.element(thumbnail));

        unawaited(
          container.read(photoRecoveryProvider.notifier).recoverFromDevice(),
        );
        await tester.pump();

        expect(
          find.descendant(
            of: thumbnail,
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget,
        );

        recovery.complete(0);
        await tester.pump();
        await tester.pump();

        expect(
          find.descendant(
            of: thumbnail,
            matching: find.byIcon(Icons.broken_image_outlined),
          ),
          findsOneWidget,
        );
      });

      testWidgets('drawer opens the recovery page', (tester) async {
        await pumpHome(tester);

        await openDrawer(tester);
        await tester.tap(find.text(_title));
        await tester.pumpAndSettle();

        expect(find.text('Delete This Photo'), findsNothing);
        expect(find.text('1 photo is not shown yet'), findsOneWidget);
      });

      testWidgets('drawer hides the entry without external photos', (
        tester,
      ) async {
        await dbClient.deleteExternalDiaryImages();
        await pumpHome(tester);

        await openDrawer(tester);

        expect(find.text(_title), findsNothing);
      });
    });

    group('date picker', () {
      Future<void> pickDate(
        WidgetTester tester, {
        required int months,
        required int day,
      }) async {
        await tester.tap(find.byKey(K.diaryDatePickerButton));
        await tester.pumpAndSettle();
        final arrow = months < 0 ? Icons.chevron_left : Icons.chevron_right;
        for (var i = 0; i < months.abs(); i++) {
          await tester.tap(find.byIcon(arrow));
          await tester.pumpAndSettle();
        }
        await tester.tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text('$day'),
          ),
        );
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
      }

      void expectOnScreen(WidgetTester tester, DateTime date) {
        final rect = tester.getRect(find.byKey(K.diaryTextField(date)));
        final screen = tester.getRect(find.byKey(K.diaryCalendar));
        expect(screen.contains(rect.center), isTrue);
      }

      for (final months in [4, -4]) {
        testWidgets('moves to a date $months months away', (tester) async {
          await pumpHome(tester);
          final now = clock.now();
          final target = DateTime(now.year, now.month + months, 15);

          await pickDate(tester, months: months, day: 15);

          expectOnScreen(tester, target);
        });
      }
    });

    group('search', () {
      final field = find.descendant(
        of: find.byType(Dialog),
        matching: find.byType(TextField),
      );

      Finder result(String content) => find.descendant(
        of: find.byType(Dialog),
        matching: find.text(content, findRichText: true),
      );

      setUp(() async {
        final today = clock.now();
        for (var i = 1; i <= 30; i++) {
          await dbClient.insertDiary(
            content: 'cafe $i',
            date: DateTime(today.year, today.month, today.day - i),
          );
        }
      });

      // The cursor of the search field keeps blinking, so the frames never
      // settle.
      Future<void> pumpFrames(WidgetTester tester) async {
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      }

      Future<void> openSearch(WidgetTester tester) async {
        await tester.tap(find.byIcon(Icons.search).first);
        await pumpFrames(tester);
      }

      Future<void> closeSearch(WidgetTester tester) async {
        await tester.tapAt(const Offset(5, 5));
        await pumpFrames(tester);
      }

      Future<void> search(WidgetTester tester, String term) async {
        await openSearch(tester);
        await tester.enterText(field, term);
        // Waits for the search after typing stops.
        await pumpFrames(tester);
        await pumpFrames(tester);
      }

      ScrollPosition resultsPosition(WidgetTester tester) {
        return tester
            .state<ScrollableState>(
              find.descendant(
                of: find.descendant(
                  of: find.byType(Dialog),
                  matching: find.byType(ListView),
                ),
                matching: find.byType(Scrollable),
              ),
            )
            .position;
      }

      testWidgets('loads the next page at the end of the results', (
        tester,
      ) async {
        await pumpHome(tester);
        await search(tester, 'cafe');
        final container = ProviderScope.containerOf(tester.element(field));
        int loadedCount() => container
            .read(diarySearchResultsProvider)
            .requireValue
            .entries
            .length;
        expect(loadedCount(), 20);

        final position = resultsPosition(tester);
        position.jumpTo(position.maxScrollExtent);
        await pumpFrames(tester);
        position.jumpTo(position.maxScrollExtent);
        await pumpFrames(tester);

        expect(loadedCount(), 30);
        expect(result('cafe 30'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(CircularProgressIndicator),
          ),
          findsNothing,
        );
      });

      testWidgets('opens again with the term, the results, and the scroll '
          'position', (tester) async {
        await pumpHome(tester);
        await search(tester, 'cafe');
        await tester.drag(result('cafe 3'), const Offset(0, -300));
        await pumpFrames(tester);
        final scrolled = resultsPosition(tester).pixels;

        await closeSearch(tester);
        await openSearch(tester);

        expect(tester.widget<TextField>(field).controller!.text, 'cafe');
        expect(scrolled, greaterThan(0));
        expect(resultsPosition(tester).pixels, scrolled);
      });

      testWidgets('opens again with the text as it was entered', (
        tester,
      ) async {
        await pumpHome(tester);
        await search(tester, ' cafe ');

        await closeSearch(tester);
        await openSearch(tester);

        expect(tester.widget<TextField>(field).controller!.text, ' cafe ');
        expect(result('cafe 1'), findsOneWidget);
      });

      testWidgets('waits for typing to stop, and then searches nothing for '
          'a term that is too short', (tester) async {
        final searchingIndicator = find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(CircularProgressIndicator),
        );
        await pumpHome(tester);
        await openSearch(tester);

        await tester.enterText(field, 'c');
        await tester.pump();
        expect(searchingIndicator, findsOneWidget);

        await pumpFrames(tester);
        expect(searchingIndicator, findsNothing);
        expect(find.text('Search results will appear here'), findsOneWidget);
      });

      testWidgets('opens again with the term after a result is opened', (
        tester,
      ) async {
        await pumpHome(tester);
        await search(tester, 'cafe');

        await tester.tap(result('cafe 1'));
        await tester.pumpAndSettle();
        await openSearch(tester);

        expect(tester.widget<TextField>(field).controller!.text, 'cafe');
        expect(result('cafe 1'), findsOneWidget);
      });

      testWidgets('opens again with a diary changed while it was closed', (
        tester,
      ) async {
        await pumpHome(tester);
        await search(tester, 'cafe');
        expect(result('cafe 1'), findsOneWidget);
        await closeSearch(tester);

        final entry = (await dbClient.searchDiaries(searchTerm: 'cafe 1'))
            .first;
        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold).first),
        );
        await container
            .read(cachedDiariesProvider.notifier)
            .updateDiary(id: entry.id, content: 'cafe one');
        await openSearch(tester);

        expect(result('cafe 1'), findsNothing);
        expect(result('cafe one'), findsOneWidget);
      });

      testWidgets('saves the term of an opened result as a recent term', (
        tester,
      ) async {
        await pumpHome(tester);
        await search(tester, 'cafe');

        await tester.tap(result('cafe 1'));
        await tester.pumpAndSettle();
        await openSearch(tester);
        await tester.enterText(field, '');
        await pumpFrames(tester);

        expect(find.text('Recent searches'), findsOneWidget);
        expect(prefsClient.recentDiarySearchTerms, ['cafe']);
      });

      testWidgets('searches a recent term at once when it is tapped', (
        tester,
      ) async {
        prefsClient = createPrefsClient(recentDiarySearchTerms: ['cafe']);
        await pumpHome(tester);
        await openSearch(tester);

        await tester.tap(find.text('cafe'));
        await tester.pump();
        await tester.pump();

        expect(tester.widget<TextField>(field).controller!.text, 'cafe');
        expect(result('cafe 1'), findsOneWidget);
      });

      testWidgets('removes one recent term, and then every term', (
        tester,
      ) async {
        prefsClient = createPrefsClient(
          recentDiarySearchTerms: ['cafe', 'rain', 'tea'],
        );
        await pumpHome(tester);
        await openSearch(tester);

        await tester.tap(find.byTooltip('Remove').first);
        await pumpFrames(tester);
        expect(prefsClient.recentDiarySearchTerms, ['rain', 'tea']);

        await tester.tap(find.text('Clear All'));
        await pumpFrames(tester);
        expect(prefsClient.recentDiarySearchTerms, isEmpty);
        expect(find.text('Recent searches'), findsNothing);
      });
    });

    testWidgets('shows a failed load and loads again on retry', (
      tester,
    ) async {
      _diariesFail = true;
      addTearDown(() => _diariesFail = false);
      await pumpHome(
        tester,
        overrides: [cachedDiariesProvider.overrideWith(_FlakyDiaries.new)],
      );

      expect(find.text('Could not load your diary'), findsOneWidget);
      expect(find.byKey(K.diaryCalendar), findsNothing);

      _diariesFail = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Could not load your diary'), findsNothing);
      expect(find.byKey(K.diaryCalendar), findsOneWidget);
    });
  });
}
