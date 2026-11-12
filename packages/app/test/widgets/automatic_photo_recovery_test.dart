// Test files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mockito/mockito.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/router/router.dart';
import 'package:onepage/widgets/widgets.dart';
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:theme/theme.dart';

import '../golden/golden_test_helpers.mocks.dart';

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
    late MockDbClient dbClient;
    late MockPrefsClient prefsClient;
    late MockHaptics haptics;
    late _FakeCommand command;
    late DiaryImage image;
    late MockDbClient Function(MockDbClient client) stubDiaries;
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

      stubDiaries = (client) {
        when(
          client.getDiaries(from: anyNamed('from'), to: anyNamed('to')),
        ).thenAnswer(
          (_) async => [
            Diary(entry: entry, images: [image]),
          ],
        );
        when(
          client.watchDiaryImageCount(),
        ).thenAnswer((_) => const Stream.empty());
        return client;
      };
      stubDiaries(dbClient);
      when(prefsClient.textInputHapticEnabled).thenReturn(false);
      when(prefsClient.otherHapticEnabled).thenReturn(false);
      when(prefsClient.photoRecoveryDismissed).thenAnswer((_) => dismissed);
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
            hapticsProvider.overrideWithValue(haptics),
            trackerProvider.overrideWithValue(MockTracker()),
            inAppReviewerProvider.overrideWith(
              (ref) async => MockInAppReviewer(),
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

    void stubExternal(List<DiaryImage> images) {
      when(
        dbClient.getExternalDiaryImages(),
      ).thenAnswer((_) async => images);
    }

    testWidgets('recovers photos when the app opens', (tester) async {
      stubExternal([image]);
      await pumpApp(tester);

      expect(command.deviceRuns, 1);
    });

    testWidgets('recovers photos again for a restored database', (
      tester,
    ) async {
      stubExternal([image]);
      await pumpApp(tester);

      dbClient = stubDiaries(MockDbClient());
      stubExternal([image]);
      tester.container().invalidate(dbClientProvider);
      await tester.pump();
      await tester.pump();

      expect(command.deviceRuns, 2);
    });

    testWidgets('reminds about the remaining photos', (tester) async {
      stubExternal([image]);
      await pumpApp(tester);

      expect(find.text(_message), findsOneWidget);

      await tester.tap(find.text('Recover'));
      await tester.pumpAndSettle();

      expect(find.text(_title), findsOneWidget);
    });

    testWidgets('does not remind after the user declines', (tester) async {
      dismissed = true;
      stubExternal([image]);
      await pumpApp(tester);

      expect(find.text(_message), findsNothing);
    });

    testWidgets('does not remind when nothing can be done', (tester) async {
      stubExternal([image]);
      await pumpApp(tester, option: DevicePhotoAccessOption.none);

      expect(find.text(_message), findsNothing);
    });

    testWidgets('does not remind without external photos', (tester) async {
      stubExternal([]);
      await pumpApp(tester);

      expect(find.text(_message), findsNothing);
    });
  });
}
