// Test files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:mockito/mockito.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/router/router.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:theme/theme.dart';

import '../golden/golden_test_helpers.mocks.dart';

const _banner = 'Some photos need to be recovered';
const _title = 'Recover Photos';

class _FakeLibrary extends Fake implements DevicePhotos {
  new(this.option);

  final DevicePhotoAccessOption option;

  @override
  Future<DevicePhotoAccessOption> get accessOption async => option;
}

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  int deviceRuns = 0;
  Completer<void>? gate;

  @override
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) async {
    deviceRuns++;
    await gate?.future;
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

    Future<void> pumpHome(
      WidgetTester tester, {
      DevicePhotoAccessOption option = DevicePhotoAccessOption.selectFolder,
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

    testWidgets('recovers photos when the page opens', (tester) async {
      stubUnmigrated([image]);
      await pumpHome(tester);

      expect(command.deviceRuns, 1);
    });

    testWidgets('recovers photos again for a restored database', (
      tester,
    ) async {
      stubUnmigrated([image]);
      await pumpHome(tester);

      dbClient = stubDiaries(MockDbClient());
      stubUnmigrated([image]);
      tester.container().invalidate(dbClientProvider);
      await tester.pump();
      await tester.pump();

      expect(command.deviceRuns, 2);
    });

    testWidgets('hides the banner when nothing can be done', (tester) async {
      stubUnmigrated([image]);
      await pumpHome(tester, option: DevicePhotoAccessOption.none);

      expect(find.text(_banner), findsNothing);
    });

    testWidgets('shows the banner while photos are recovered', (tester) async {
      command.gate = Completer();
      stubUnmigrated([image]);
      await pumpHome(tester, option: DevicePhotoAccessOption.none);

      expect(find.text(_banner), findsOneWidget);

      command.gate!.complete();
      await tester.pump();
      await tester.pump();
    });

    testWidgets('hides the banner without unmigrated photos', (tester) async {
      stubUnmigrated([]);
      await pumpHome(tester);

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
