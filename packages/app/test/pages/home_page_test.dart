// Test files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/router/router.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:theme/theme.dart';

import '../utils/clients.dart';
import '../utils/mock.dart';

const _title = 'Recover Photos';

class _FakeLibrary extends Fake implements DevicePhotos {
  new(this.option);

  final DevicePhotoAccessOption option;

  @override
  Future<DevicePhotoAccessOption> accessOption(List<String> ids) async =>
      option;
}

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  Future<int> recovery = Future.syncValue(0);

  @override
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) {
    return recovery;
  }
}

void main() {
  group('HomePage photo recovery', () {
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
      prefsClient = await createPrefsClient();
      command = _FakeCommand();
    });

    Future<void> pumpHome(
      WidgetTester tester, {
      DevicePhotoAccessOption option = DevicePhotoAccessOption.requestPhotos,
    }) async {
      LocaleSettings.setLocaleRawSync('en');
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final router = GoRouter(routes: $appRoutes);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dbClientProvider.overrideWith((ref) => dbClient),
            prefsClientProvider.overrideWithValue(prefsClient),
            trackerProvider.overrideWithValue(
              createTracker(MockFirebaseCrashlytics()),
            ),
            inAppReviewerProvider.overrideWith(
              (ref) async => createInAppReviewer(prefsClient),
            ),
            devicePhotosProvider.overrideWithValue(_FakeLibrary(option)),
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

    Future<void> openDrawer(WidgetTester tester) async {
      tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
      await tester.pumpAndSettle();
    }

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
}
