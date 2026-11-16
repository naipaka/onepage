import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/router/router.dart';
import 'package:onepage/widgets/widgets.dart';
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:theme/theme.dart';

import '../utils/clients.dart';

const _message = 'Some photos need to be recovered';
const _title = 'Recover Photos';

class _FakeLibrary extends Fake implements DevicePhotos {
  new(this.option);

  final DevicePhotoAccessOption option;

  @override
  Future<DevicePhotoAccessOption> accessOption(List<String> ids) async =>
      option;
}

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  int deviceRuns = 0;

  @override
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) async {
    deviceRuns++;
    return 0;
  }
}

void main() {
  group('AutomaticPhotoRecovery', () {
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

    Future<void> pumpApp(
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
            trackerProvider.overrideWithValue(createTracker()),
            inAppReviewerProvider.overrideWith(
              (ref) async => createInAppReviewer(),
            ),
            devicePhotosProvider.overrideWithValue(_FakeLibrary(option)),
            photoRecoveryCommandProvider.overrideWithValue(command),
            routerProvider.overrideWithValue(router),
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
              builder: (_, child) => AutomaticPhotoRecovery(child: child!),
            ),
          ),
        ),
      );
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('recovers photos when the app opens', (tester) async {
      await pumpApp(tester);

      expect(command.deviceRuns, 1);
    });

    testWidgets('recovers photos again for a restored database', (
      tester,
    ) async {
      await pumpApp(tester);

      dbClient = await createDbClientWithPhoto();
      tester.container().invalidate(dbClientProvider);
      await tester.pump();
      await tester.pump();

      expect(command.deviceRuns, 2);
    });

    testWidgets('reminds about the remaining photos', (tester) async {
      await pumpApp(tester);

      expect(find.text(_message), findsOneWidget);

      await tester.tap(find.text('Recover'));
      await tester.pumpAndSettle();

      expect(find.text(_title), findsOneWidget);
    });

    testWidgets('does not remind after the user declines', (tester) async {
      prefsClient = createPrefsClient(photoRecoveryDismissed: true);
      await pumpApp(tester);

      expect(find.text(_message), findsNothing);
    });

    testWidgets('does not remind when nothing can be done', (tester) async {
      await pumpApp(tester, option: DevicePhotoAccessOption.none);

      expect(find.text(_message), findsNothing);
    });

    testWidgets('does not remind without external photos', (tester) async {
      await dbClient.deleteExternalDiaryImages();
      await pumpApp(tester);

      expect(find.text(_message), findsNothing);
    });
  });
}
