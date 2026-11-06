// Test files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:mockito/mockito.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';
import 'package:photo_client/photo_client.dart';
import 'package:theme/theme.dart';

import '../golden/golden_test_helpers.mocks.dart';

class _FakeLibrary extends Fake implements PhotoLibrary {
  new({required this.access, required this.folderSupported});

  final PhotoLibraryAccess access;
  final bool folderSupported;
  String? folder = 'folder';
  int settingsOpened = 0;

  @override
  Future<PhotoLibraryAccess> requestAccess() async => access;

  @override
  Future<bool> get supportsFolder async => folderSupported;

  @override
  Future<String?> pickFolder() async => folder;

  @override
  Future<void> openSettings() async => settingsOpened++;
}

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  int libraryRuns = 0;

  @override
  Future<int> recoverFromLibrary({PhotoRecoveryProgress? onProgress}) async {
    libraryRuns++;
    onProgress?.call(1, 1);
    return 0;
  }

  @override
  Future<int> recoverFromFolder(
    String folder, {
    PhotoRecoveryProgress? onProgress,
  }) async {
    return 2;
  }
}

void main() {
  group('PhotoRecoveryPage', () {
    late MockTracker tracker;
    late MockPrefsClient prefsClient;
    late _FakeCommand command;
    late List<DiaryImage> images;
    var dismissed = false;

    DiaryImage image() {
      final now = clock.now();
      return DiaryImage(
        id: 1,
        diaryId: 1,
        photoId: 'a',
        createdAt: now,
        updatedAt: now,
      );
    }

    setUp(() {
      dismissed = false;
      tracker = MockTracker();
      prefsClient = MockPrefsClient();
      command = _FakeCommand();
      images = [image()];

      when(prefsClient.otherHapticEnabled).thenReturn(false);
      when(prefsClient.photoRecoveryDismissed).thenAnswer((_) => dismissed);
      when(
        prefsClient.setPhotoRecoveryDismissed(
          dismissed: anyNamed('dismissed'),
        ),
      ).thenAnswer((_) async {
        dismissed = true;
        return true;
      });
      when(
        tracker.recordError(any, any, fatal: anyNamed('fatal')),
      ).thenAnswer((_) async {});
    });

    Future<void> pumpPage(
      WidgetTester tester, {
      PhotoLibraryAccess access = PhotoLibraryAccess.denied,
      bool folderSupported = true,
      _FakeLibrary? library,
      int? imageId,
    }) async {
      LocaleSettings.setLocaleRawSync('en');
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final dbClient = MockDbClient();
      when(dbClient.getUnmigratedDiaryImages()).thenAnswer((_) async => images);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dbClientProvider.overrideWithValue(dbClient),
            photoLibraryProvider.overrideWithValue(
              library ??
                  _FakeLibrary(
                    access: access,
                    folderSupported: folderSupported,
                  ),
            ),
            photoRecoveryCommandProvider.overrideWithValue(command),
            prefsClientProvider.overrideWithValue(prefsClient),
            trackerProvider.overrideWithValue(tracker),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              theme: appLightThemeData,
              localizationsDelegates: localizationsDelegates,
              supportedLocales: AppLocaleUtils.supportedLocales,
              locale: const Locale('en'),
              home: PhotoRecoveryPage(imageId: imageId),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester
          .container()
          .read(photoRecoveryProvider.notifier)
          .importFromLibrary();
      await tester.pump();
      await tester.pump();
    }

    testWidgets('offers folder selection when it is supported', (tester) async {
      await pumpPage(tester);

      expect(find.text('Photos left to recover: 1'), findsOneWidget);
      expect(find.text('Select Folder'), findsOneWidget);
      expect(find.text('Do Not Recover the Remaining Photos'), findsOneWidget);
    });

    testWidgets('does not import from a denied library', (tester) async {
      await pumpPage(tester);

      expect(command.libraryRuns, 0);
    });

    testWidgets('imports from an allowed library once', (tester) async {
      await pumpPage(tester, access: PhotoLibraryAccess.limited);

      await tester
          .container()
          .read(photoRecoveryProvider.notifier)
          .importFromLibrary();

      expect(command.libraryRuns, 1);
    });

    testWidgets('guides to Settings without folder selection', (tester) async {
      final library = _FakeLibrary(
        access: PhotoLibraryAccess.limited,
        folderSupported: false,
      );
      await pumpPage(tester, library: library);

      await tester.tap(find.text('Open Settings'));
      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      expect(library.settingsOpened, 1);
      expect(command.libraryRuns, 2);
    });

    testWidgets('reports missing originals with full access', (tester) async {
      await pumpPage(
        tester,
        access: PhotoLibraryAccess.full,
        folderSupported: false,
      );

      expect(find.textContaining('could not be found'), findsOneWidget);
      expect(find.text('Do Not Recover the Remaining Photos'), findsNothing);
    });

    testWidgets('returns the recovered count after folder selection', (
      tester,
    ) async {
      await pumpPage(tester);

      final recovered = await tester
          .container()
          .read(photoRecoveryProvider.notifier)
          .importFromFolder();

      expect(recovered, 2);
      expect(tester.container().read(photoRecoveryProvider).isRunning, isFalse);
    });

    testWidgets('does nothing when folder selection is canceled', (
      tester,
    ) async {
      final library = _FakeLibrary(
        access: PhotoLibraryAccess.denied,
        folderSupported: true,
      )..folder = null;
      await pumpPage(tester, library: library);

      final recovered = await tester
          .container()
          .read(photoRecoveryProvider.notifier)
          .importFromFolder();

      expect(recovered, isNull);
    });

    testWidgets('dismisses the reminder', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('Do Not Recover the Remaining Photos'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Do Not Recover the Remaining Photos'), findsNothing);
    });

    testWidgets('shows delete only when opened from a photo', (tester) async {
      await pumpPage(tester);
      expect(find.text('Delete This Photo'), findsNothing);

      await pumpPage(tester, imageId: 1);
      expect(find.text('Delete This Photo'), findsOneWidget);
    });
  });
}
