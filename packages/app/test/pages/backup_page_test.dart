// Test files do not need to specify provider dependencies
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'dart:async';

import 'package:backup/backup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:mockito/mockito.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';
import 'package:theme/theme.dart';

import '../golden/golden_test_helpers.mocks.dart';

void main() {
  group('BackupPage', () {
    late MockBackupController controller;
    late MockTracker tracker;
    late MockPrefsClient prefsClient;

    setUp(() {
      controller = MockBackupController();
      tracker = MockTracker();
      prefsClient = MockPrefsClient();

      when(prefsClient.otherHapticEnabled).thenReturn(false);
      when(prefsClient.textInputHapticEnabled).thenReturn(false);
      when(
        tracker.recordError(any, any, fatal: anyNamed('fatal')),
      ).thenAnswer((_) async {});
    });

    MockDbClient createDbClient() {
      final client = MockDbClient();
      when(client.watchDiaryImageCount()).thenAnswer(
        (_) => const Stream.empty(),
      );
      return client;
    }

    Future<void> pumpPage(WidgetTester tester) async {
      LocaleSettings.setLocaleRawSync('en');
      await tester.binding.setSurfaceSize(const Size(800, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            backupControllerProvider.overrideWithValue(controller),
            dbClientProvider.overrideWith((_) => createDbClient()),
            trackerProvider.overrideWithValue(tracker),
            prefsClientProvider.overrideWithValue(prefsClient),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              theme: appLightThemeData,
              localizationsDelegates: localizationsDelegates,
              supportedLocales: AppLocaleUtils.supportedLocales,
              locale: const Locale('en'),
              home: const BackupPage(),
            ),
          ),
        ),
      );
    }

    Future<void> showToast(WidgetTester tester) async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
    }

    Future<void> dismissToast(WidgetTester tester) async {
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }

    void stubCreate(Future<void> Function(BackupProgressCallback) answer) {
      when(
        controller.createBackupFile(onProgress: anyNamed('onProgress')),
      ).thenAnswer((invocation) {
        return answer(
          invocation.namedArguments[#onProgress] as BackupProgressCallback,
        );
      });
    }

    void stubRestore(Future<void> Function(BackupProgressCallback) answer) {
      when(
        controller.restoreBackupFile(any, onProgress: anyNamed('onProgress')),
      ).thenAnswer((invocation) {
        return answer(
          invocation.namedArguments[#onProgress] as BackupProgressCallback,
        );
      });
    }

    void stubPick({required bool isLegacy}) {
      when(controller.pickBackupFile()).thenAnswer(
        (_) async => BackupFile(path: 'a.backup', isLegacy: isLegacy),
      );
    }

    group('create', () {
      testWidgets('shows progress while creating a backup', (tester) async {
        final completer = Completer<void>();
        stubCreate((onProgress) {
          onProgress(1, 2);
          return completer.future;
        });
        await pumpPage(tester);

        await tester.tap(find.text('Create Backup'));
        await tester.pump();
        await tester.pump();

        expect(find.text('Creating backup'), findsOneWidget);
        expect(find.text('1 / 2'), findsOneWidget);

        completer.complete();
        await tester.pump();
        await showToast(tester);

        expect(find.text('Creating backup'), findsNothing);
        expect(find.text('Backup created successfully!'), findsOneWidget);
        await dismissToast(tester);
      });

      testWidgets('shows an error when creating fails', (tester) async {
        stubCreate((_) async => throw Exception('failed'));
        await pumpPage(tester);

        await tester.tap(find.text('Create Backup'));
        await tester.pump();
        await showToast(tester);

        expect(find.text('Creating backup'), findsNothing);
        expect(find.text('Failed to create backup'), findsOneWidget);
        verify(tracker.recordError(any, any, fatal: true)).called(1);
        await dismissToast(tester);
      });
    });

    group('restore', () {
      testWidgets('does nothing when the picker is canceled', (tester) async {
        when(controller.pickBackupFile()).thenAnswer((_) async => null);
        await pumpPage(tester);

        await tester.tap(find.text('Restore Backup'));
        await tester.pump();

        verifyNever(
          controller.restoreBackupFile(any, onProgress: anyNamed('onProgress')),
        );
      });

      testWidgets('shows an error when picking a file fails', (tester) async {
        when(controller.pickBackupFile()).thenThrow(Exception('failed'));
        await pumpPage(tester);
        final client = tester.container().read(dbClientProvider);

        await tester.tap(find.text('Restore Backup'));
        await showToast(tester);

        expect(find.text('Failed to restore backup'), findsOneWidget);
        expect(tester.container().read(dbClientProvider), same(client));
        verifyNever(client.close());
        verifyNever(
          controller.restoreBackupFile(any, onProgress: anyNamed('onProgress')),
        );
        verify(tracker.recordError(any, any, fatal: true)).called(1);
        await dismissToast(tester);
      });

      testWidgets('shows progress while restoring', (tester) async {
        final completer = Completer<void>();
        stubPick(isLegacy: false);
        stubRestore((onProgress) {
          onProgress(2, 5);
          return completer.future;
        });
        await pumpPage(tester);

        await tester.tap(find.text('Restore Backup'));
        await tester.pump();
        await tester.pump();

        expect(find.text('Restoring backup'), findsOneWidget);
        expect(find.text('2 / 5'), findsOneWidget);

        completer.complete();
        await tester.pumpAndSettle();

        expect(find.text('Restoring backup'), findsNothing);
        expect(
          find.text('Restoring your backup was successful'),
          findsOneWidget,
        );
      });

      testWidgets('keeps the data when a legacy restore is canceled', (
        tester,
      ) async {
        stubPick(isLegacy: true);
        await pumpPage(tester);

        await tester.tap(find.text('Restore Backup'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        verifyNever(
          controller.restoreBackupFile(any, onProgress: anyNamed('onProgress')),
        );
      });

      testWidgets('restores a legacy backup after confirmation', (
        tester,
      ) async {
        stubPick(isLegacy: true);
        stubRestore((_) async {});
        await pumpPage(tester);

        await tester.tap(find.text('Restore Backup'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Restore'));
        await tester.pumpAndSettle();

        expect(
          find.text('Restoring your backup was successful'),
          findsOneWidget,
        );
      });

      testWidgets('shows an error when restoring fails', (tester) async {
        stubPick(isLegacy: false);
        stubRestore((_) async => throw Exception('failed'));
        await pumpPage(tester);
        final client = tester.container().read(dbClientProvider);

        await tester.tap(find.text('Restore Backup'));
        await tester.pump();
        await tester.pump();
        await showToast(tester);

        expect(find.text('Restoring backup'), findsNothing);
        expect(find.text('Failed to restore backup'), findsOneWidget);
        expect(
          tester.container().read(dbClientProvider),
          isNot(same(client)),
        );
        verify(tracker.recordError(any, any, fatal: true)).called(1);
        await dismissToast(tester);
      });
    });
  });
}
