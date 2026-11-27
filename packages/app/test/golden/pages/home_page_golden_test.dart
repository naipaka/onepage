@Tags(['golden'])
library;

import 'dart:async';
import 'dart:io';

import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/keys.dart';
import 'package:onepage/pages/pages.dart';
import 'package:onepage/widgets/widgets.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_storage/photo_storage.dart';

import '../../utils/clients.dart';
import '../golden_fakes.dart';
import '../golden_test_helpers.dart';

/// Today in the images, a few days after the start of a month, so that the
/// screen shows the line between two months.
final _now = DateTime(2025, 2, 3, 12);

/// The diary texts of a language, and the search terms that find some of
/// them and none of them.
typedef _Texts = ({
  String morning,
  String rain,
  String today,
  String cafe,
  String found,
  String missing,
});

const _english = (
  morning: 'Went for a walk before work.\nThe air was cold and clear.',
  rain: 'It rained all day, so I stayed in and read a book.',
  today: 'Tried the new cafe near the station.',
  cafe: 'Had coffee at the cafe by the river.',
  found: 'cafe',
  missing: 'mountain',
);

const _japanese = (
  morning: '仕事の前に散歩した。\n空気が冷たくて澄んでいた。',
  rain: '一日中雨だったので、家で本を読んだ。',
  today: '駅の近くの新しいカフェに行ってみた。',
  cafe: '川沿いのカフェでコーヒーを飲んだ。',
  found: 'カフェ',
  missing: '山登り',
);

_Texts _textsOf(GoldenVariant variant) {
  return switch (variant.locale.languageCode) {
    'ja' => _japanese,
    _ => _english,
  };
}

/// Days with a text, with a photo, with a photo missing from the app, and
/// days with nothing, around [_now].
Future<(DbClient, PhotoStorage)> _diaries(
  WidgetTester tester,
  _Texts texts,
) async {
  final dbClient = createDbClient();
  final storage = await tester.runAsync(() async {
    final directory = await Directory.systemTemp.createTemp('photos');
    addTearDown(() => directory.delete(recursive: true));
    final storage = PhotoStorage(directory: directory);

    await dbClient.insertDiary(
      content: texts.morning,
      date: DateTime(2025, 1, 31),
    );
    final withPhoto = await dbClient.insertDiary(
      content: texts.rain,
      date: DateTime(2025, 2),
    );
    await dbClient.insertDiaryImage(
      diaryId: withPhoto.id,
      fileName: await GoldenTestHelpers.savePhoto(storage),
    );
    final withMissingPhoto = await dbClient.insertDiary(
      content: '',
      date: DateTime(2025, 2, 2),
    );
    await insertExternalDiaryImage(
      dbClient,
      diaryId: withMissingPhoto.id,
      photoId: 'a',
    );
    await dbClient.insertDiary(content: texts.today, date: _now);
    // More than one page of search results, before the days on the screen.
    for (var day = 1; day <= 25; day++) {
      await dbClient.insertDiary(
        content: texts.cafe,
        date: DateTime(2024, 12, day),
      );
    }
    return storage;
  });
  return (dbClient, storage!);
}

final _searchField = find.descendant(
  of: find.byType(Dialog),
  matching: find.byType(TextField),
);

/// Diaries that fail to load.
class _FailingDiaries extends CachedDiaries {
  @override
  Future<DiariesWithDates> build() => Future.error(Exception('failed'));
}

/// A search whose next page keeps loading.
class _LoadingMoreSearch extends DiarySearch {
  @override
  Future<void> loadMore() => Completer<void>().future;
}

void main() {
  group('HomePage Golden Tests', () {
    Future<void> expectGoldenMatches(
      WidgetTester tester,
      String name, {
      required GoldenVariant variant,
      Widget page = const HomePage(),
      bool recoveryRuns = false,
      List<Override> overrides = const [],
      Future<void> Function(WidgetTester tester, _Texts texts)? act,
    }) async {
      final texts = _textsOf(variant);
      final (dbClient, photoStorage) = await _diaries(tester, texts);
      await GoldenTestHelpers.expectGoldenMatches(
        tester,
        page,
        name,
        variant: variant,
        now: _now,
        dbClient: dbClient,
        photoStorage: photoStorage,
        overrides: [
          devicePhotosProvider.overrideWithValue(FakeDevicePhotos()),
          photoRecoveryCommandProvider.overrideWithValue(
            FakePhotoRecoveryCommand(running: recoveryRuns),
          ),
          ...overrides,
        ],
        act: act == null ? null : (tester) => act(tester, texts),
      );
    }

    Future<void> openPhotoViewer(WidgetTester tester) async {
      await tester.tap(
        find.byWidgetPredicate((w) => w is PhotoThumbnail && w.file != null),
      );
      await tester.pumpAndSettle();
      await GoldenTestHelpers.loadImages(tester);
    }

    Future<void> openSearch(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.search));
      // The cursor of the search field keeps blinking, so the frames never
      // settle.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    Future<void> search(WidgetTester tester, String term) async {
      await openSearch(tester);
      await tester.enterText(_searchField, term);
      // Waits for the search after typing stops.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }

    for (final variant in GoldenVariant.values) {
      testWidgets('renders the days with the reminder of photos to recover '
          'with ${variant.suffix}', (tester) async {
        await expectGoldenMatches(
          tester,
          'home_page',
          variant: variant,
          page: const AutomaticPhotoRecovery(child: HomePage()),
        );
      });

      testWidgets('renders a running photo recovery with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_recovering',
          variant: variant,
          recoveryRuns: true,
          act: (tester, _) async {
            unawaited(
              ProviderScope.containerOf(
                tester.element(find.byType(HomePage)),
              ).read(photoRecoveryProvider.notifier).recoverFromDevice(),
            );
            // The loading indicators keep moving, so the frames never settle.
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 500));
          },
        );
      });

      testWidgets('renders the toolbar of the keyboard with '
          '${variant.suffix}', (tester) async {
        await expectGoldenMatches(
          tester,
          'home_page_editing',
          variant: variant,
          act: (tester, _) async {
            // The heights of the English keyboard with the predictive text
            // bar and the Japanese kana keyboard on a 375 x 812 iPhone with
            // iOS 27.2.
            tester.view.viewInsets = FakeViewPadding(
              bottom: switch (variant.locale.languageCode) {
                'ja' => 344,
                _ => 337,
              },
            );
            await tester.tap(find.byKey(K.diaryTextField(_now)));
            // The cursor keeps blinking, so the frames never settle.
            await tester.pump();
            await tester.pump(const Duration(seconds: 1));
          },
        );
      });

      testWidgets('renders the photo viewer with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_photo_viewer',
          variant: variant,
          act: (tester, _) => openPhotoViewer(tester),
        );
      });

      testWidgets('renders the confirmation of deleting a photo with '
          '${variant.suffix}', (tester) async {
        await expectGoldenMatches(
          tester,
          'home_page_delete_photo',
          variant: variant,
          act: (tester, _) async {
            await openPhotoViewer(tester);
            await tester.tap(find.byIcon(Icons.delete));
            await tester.pumpAndSettle();
          },
        );
      });

      testWidgets('renders the notice about photos with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_photo_notice',
          variant: variant,
          act: (tester, _) async {
            await openPhotoViewer(tester);
            await tester.tap(find.byIcon(Icons.info_outline));
            await tester.pumpAndSettle();
          },
        );
      });

      testWidgets('renders the drawer with ${variant.suffix}', (tester) async {
        await expectGoldenMatches(
          tester,
          'home_page_drawer',
          variant: variant,
          act: (tester, _) async {
            await tester.tap(find.byType(DrawerButton));
            await tester.pumpAndSettle();
            await GoldenTestHelpers.loadImages(tester);
          },
        );
      });

      testWidgets('renders the date picker with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_date_picker',
          variant: variant,
          act: (tester, _) async {
            await tester.tap(find.byKey(K.diaryDatePickerButton));
            await tester.pumpAndSettle();
          },
        );
      });

      testWidgets('renders the search before typing with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_search',
          variant: variant,
          act: (tester, _) => openSearch(tester),
        );
      });

      testWidgets('renders a search in progress with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_searching',
          variant: variant,
          act: (tester, texts) async {
            await openSearch(tester);
            await tester.enterText(_searchField, texts.found);
            // The search starts a second after typing stops.
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 500));
          },
        );
      });

      testWidgets('renders the search results loading more with '
          '${variant.suffix}', (tester) async {
        await expectGoldenMatches(
          tester,
          'home_page_search_results',
          variant: variant,
          overrides: [diarySearchProvider.overrideWith(_LoadingMoreSearch.new)],
          act: (tester, texts) async {
            await search(tester, texts.found);
            final position = tester
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
            position.jumpTo(position.maxScrollExtent);
            // The loading indicator keeps moving, so the frames never settle.
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 500));
          },
        );
      });

      testWidgets('renders a search with no results with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_search_no_results',
          variant: variant,
          act: (tester, texts) => search(tester, texts.missing),
        );
      });

      testWidgets('renders diaries that fail to load with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'home_page_error',
          variant: variant,
          overrides: [cachedDiariesProvider.overrideWith(_FailingDiaries.new)],
        );
      });
    }
  });
}
