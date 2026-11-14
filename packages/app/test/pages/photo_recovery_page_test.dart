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
import 'package:mockito/mockito.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';
import 'package:onepage/router/router.dart';
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:theme/theme.dart';

import '../golden/golden_test_helpers.mocks.dart';

class _FakeLibrary extends Fake implements DevicePhotos {
  new(this.option);

  final DevicePhotoAccessOption option;
  int settingsOpened = 0;
  int accessRequests = 0;
  DevicePhotoAccessRequest request = DevicePhotoAccessRequest.allowed;

  @override
  Future<DevicePhotoAccessOption> accessOption(List<String> ids) async =>
      option;

  @override
  Future<void> openSettings() async => settingsOpened++;

  @override
  Future<DevicePhotoAccessRequest> requestAccess() async {
    accessRequests++;
    return request;
  }
}

// GoRouterState has no public constructor for tests.
// ignore: avoid_implementing_value_types
class _FakeRouterState extends Fake implements GoRouterState;

class _FakeCommand extends Fake implements PhotoRecoveryCommand {
  int deviceRuns = 0;
  int requestedRuns = 0;
  int? allowed = 1;
  Exception? error;
  Completer<void>? gate;

  @override
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) async {
    deviceRuns++;
    onProgress?.call(1, 1);
    return 0;
  }

  @override
  Future<int?> recoverRequested({PhotoRecoveryProgress? onProgress}) async {
    requestedRuns++;
    final allowed = this.allowed;
    if (allowed == null) {
      return null;
    }
    onProgress?.call(1, 2);
    await gate?.future;
    if (error case final error?) {
      throw error;
    }
    return allowed;
  }
}

void main() {
  group('PhotoRecoveryPage', () {
    late MockTracker tracker;
    late MockPrefsClient prefsClient;
    late MockDbClient dbClient;
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
      dbClient = MockDbClient();
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
      when(tracker.recordError(any, any)).thenAnswer((_) async {});
    });

    Future<void> pumpPage(
      WidgetTester tester, {
      DevicePhotoAccessOption option = DevicePhotoAccessOption.requestPhotos,
      _FakeLibrary? library,
      int? imageId,
    }) async {
      LocaleSettings.setLocaleRawSync('en');
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      when(dbClient.getExternalDiaryImages()).thenAnswer((_) async => images);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dbClientProvider.overrideWithValue(dbClient),
            devicePhotosProvider.overrideWithValue(
              library ?? _FakeLibrary(option),
            ),
            photoRecoveryCommandProvider.overrideWithValue(command),
            prefsClientProvider.overrideWithValue(prefsClient),
            photoStorageProvider.overrideWithValue(
              PhotoStorage(directory: Directory.systemTemp),
            ),
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
      await tester.pump();
      await tester.pump();
    }

    Future<void> showToast(WidgetTester tester) async {
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
    }

    Future<void> dismissToast(WidgetTester tester) async {
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }

    testWidgets('offers recovery for photos not shown yet', (tester) async {
      await pumpPage(tester);

      expect(find.text('1 photo is not shown yet'), findsOneWidget);
      expect(find.text('Recover'), findsOneWidget);
      expect(find.text('Do Not Recover the Remaining Photos'), findsOneWidget);
    });

    testWidgets('recovers the photos the user allows', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('Recover'));
      await tester.pump();
      await tester.pump();
      await showToast(tester);

      expect(command.requestedRuns, 1);
      expect(find.text('Photos recovered: 1'), findsOneWidget);
      await dismissToast(tester);
    });

    testWidgets('does nothing when the user declines the photos', (
      tester,
    ) async {
      command.allowed = null;
      await pumpPage(tester);

      await tester.tap(find.text('Recover'));
      await tester.pumpAndSettle();

      expect(command.requestedRuns, 1);
      expect(find.textContaining('Photos recovered'), findsNothing);
      expect(tester.container().read(photoRecoveryProvider), isNull);
    });

    testWidgets('recovers after the user allows access', (tester) async {
      final library = _FakeLibrary(DevicePhotoAccessOption.openSettings);
      await pumpPage(tester, library: library);

      await tester.tap(find.text('Recover'));
      await tester.pumpAndSettle();

      expect(library.accessRequests, 1);
      expect(command.deviceRuns, 1);
    });

    testWidgets('does nothing when the user declines', (tester) async {
      final library = _FakeLibrary(DevicePhotoAccessOption.openSettings)
        ..request = DevicePhotoAccessRequest.declined;
      await pumpPage(tester, library: library);

      await tester.tap(find.text('Recover'));
      await tester.pumpAndSettle();

      expect(command.deviceRuns, 0);
      expect(find.text('Allow photo access in Settings'), findsNothing);
    });

    testWidgets('guides to Settings when the system cannot ask', (
      tester,
    ) async {
      final library = _FakeLibrary(DevicePhotoAccessOption.openSettings)
        ..request = DevicePhotoAccessRequest.unavailable;
      await pumpPage(tester, library: library);

      await tester.tap(find.text('Recover'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();

      expect(library.settingsOpened, 1);
      expect(command.deviceRuns, 0);
    });

    testWidgets('reports missing originals with full access', (tester) async {
      await pumpPage(tester, option: DevicePhotoAccessOption.none);

      expect(
        find.text('1 photo cannot be found on this device'),
        findsOneWidget,
      );
      expect(find.text('Delete Photos That Are Not Shown'), findsOneWidget);
      expect(find.text('Do Not Recover the Remaining Photos'), findsNothing);
    });

    testWidgets('returns the recovered count of the allowed photos', (
      tester,
    ) async {
      await pumpPage(tester);

      final recovered = await tester
          .container()
          .read(photoRecoveryProvider.notifier)
          .recoverRequested();

      expect(recovered, 1);
      expect(tester.container().read(photoRecoveryProvider), isNull);
    });

    testWidgets('shows progress while recovering', (tester) async {
      command.gate = Completer();
      await pumpPage(tester);

      await tester.tap(find.text('Recover'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Recovering photos'), findsOneWidget);
      expect(find.text('1 / 2'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      command.gate!.complete();
      await showToast(tester);
      await dismissToast(tester);
    });

    testWidgets('does not start a second recovery', (tester) async {
      command.gate = Completer();
      await pumpPage(tester);
      final notifier = tester.container().read(photoRecoveryProvider.notifier);

      final running = notifier.recoverRequested();
      await tester.pump();
      await notifier.recoverFromDevice();

      expect(command.deviceRuns, 0);
      command.gate!.complete();
      await running;
    });

    testWidgets('shows an error when recovery fails', (tester) async {
      command.error = Exception('failed');
      await pumpPage(tester);

      await tester.tap(find.text('Recover'));
      await showToast(tester);

      expect(find.text('Could not recover photos'), findsOneWidget);
      expect(find.text('Recover'), findsOneWidget);
      verify(tracker.recordError(any, any)).called(1);
      await dismissToast(tester);
    });

    Future<void> openDelete(WidgetTester tester) async {
      when(
        dbClient.getDiaries(from: anyNamed('from'), to: anyNamed('to')),
      ).thenAnswer((_) async => []);
      when(
        dbClient.deleteDiaryImage(id: anyNamed('id')),
      ).thenAnswer((_) async => null);
      await pumpPage(tester);
      tester.container().listen(cachedDiariesProvider, (_, _) {});
      await tester.container().read(cachedDiariesProvider.future);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator
          .push(
            MaterialPageRoute<void>(
              builder: (_) => const PhotoRecoveryPage(imageId: 1),
            ),
          )
          .ignore();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete This Photo'));
      await tester.pumpAndSettle();
    }

    testWidgets('deletes the photo after confirmation', (tester) async {
      await openDelete(tester);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      verify(dbClient.deleteDiaryImage(id: 1)).called(1);
      expect(find.text('Delete This Photo'), findsNothing);
    });

    testWidgets('keeps the photo when deletion is canceled', (tester) async {
      await openDelete(tester);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(dbClient.deleteDiaryImage(id: anyNamed('id')));
      expect(find.text('Delete This Photo'), findsOneWidget);
    });

    testWidgets('deletes the photos that are not shown', (tester) async {
      when(
        dbClient.getDiaries(from: anyNamed('from'), to: anyNamed('to')),
      ).thenAnswer((_) async => []);
      when(dbClient.deleteExternalDiaryImages()).thenAnswer((_) async {});
      await pumpPage(tester);
      tester.container().listen(cachedDiariesProvider, (_, _) {});
      await tester.container().read(cachedDiariesProvider.future);

      await tester.tap(find.text('Delete Photos That Are Not Shown'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('1 photo that is not shown'),
        findsOneWidget,
      );
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      verify(dbClient.deleteExternalDiaryImages()).called(1);
    });

    testWidgets('keeps the photos when deletion is canceled', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('Delete Photos That Are Not Shown'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(dbClient.deleteExternalDiaryImages());
    });

    testWidgets('shows that every photo is recovered', (tester) async {
      images = [];
      await pumpPage(tester);

      expect(find.text('All photos have been recovered'), findsOneWidget);
      expect(find.text('Back to Diary'), findsOneWidget);
      expect(find.text('Recover'), findsNothing);
    });

    testWidgets('route opens the page for an image', (tester) async {
      await pumpPage(tester);

      final page = const PhotoRecoveryRouteData(
        imageId: 1,
      ).build(tester.element(find.byType(Scaffold).first), _FakeRouterState());

      expect((page as PhotoRecoveryPage).imageId, 1);
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
