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

const _title = 'Recover Photos';

class _FakeLibrary extends Fake implements DevicePhotos {
  new(this.option);

  final DevicePhotoAccessOption option;

  @override
  Future<DevicePhotoAccessOption> get accessOption async => option;
}

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  Future<int> recovery = Future.value(0);

  @override
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) {
    return recovery;
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

    void stubExternal(List<DiaryImage> images) {
      when(
        dbClient.getExternalDiaryImages(),
      ).thenAnswer((_) async => images);
    }

    Future<void> openDrawer(WidgetTester tester) async {
      tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
      await tester.pumpAndSettle();
    }

    testWidgets('placeholder opens the page for its photo', (tester) async {
      stubExternal([image]);
      await pumpHome(tester);

      await tester.tap(find.byType(PhotoThumbnail));
      await tester.pumpAndSettle();

      expect(find.text('Delete This Photo'), findsOneWidget);
    });

    testWidgets('placeholder shows progress while recovering', (
      tester,
    ) async {
      stubExternal([image]);
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
      stubExternal([image]);
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
      stubExternal([]);
      await pumpHome(tester);

      await openDrawer(tester);

      expect(find.text(_title), findsNothing);
    });
  });
}
