@Tags(['golden'])
library;

import 'dart:async';

import 'package:backup/backup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n/i18n.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';

import '../golden_test_helpers.dart';

class _FakeBackupController extends Fake implements BackupController {
  new({this.progress, this.isLegacy = false, this.restoreCompletes = false});

  /// The progress that a backup or a restore reports before it stops.
  final (int, int)? progress;

  /// Whether the picked backup file is from an old version of the app.
  final bool isLegacy;

  /// Whether a restore completes, instead of running until the test ends.
  final bool restoreCompletes;

  Future<void> _run(BackupProgressCallback? onProgress) {
    if (progress case (final completed, final total)) {
      onProgress?.call(completed, total);
    }
    return Completer<void>().future;
  }

  @override
  Future<void> createBackupFile({BackupProgressCallback? onProgress}) {
    return _run(onProgress);
  }

  @override
  Future<BackupFile?> pickBackupFile() async {
    return BackupFile(path: 'onepage.backup', isLegacy: isLegacy);
  }

  @override
  Future<void> restoreBackupFile(
    BackupFile backupFile, {
    BackupProgressCallback? onProgress,
  }) async {
    if (restoreCompletes) {
      return;
    }
    return _run(onProgress);
  }
}

void main() {
  group('BackupPage Golden Tests', () {
    for (final variant in GoldenVariant.values) {
      testWidgets('renders the page with ${variant.suffix}', (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const BackupPage(),
          'backup_page',
          variant: variant,
        );
      });

      testWidgets('renders the progress of a backup with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const BackupPage(),
          'backup_page_creating',
          variant: variant,
          overrides: [
            backupControllerProvider.overrideWithValue(
              _FakeBackupController(progress: (3, 10)),
            ),
          ],
          act: (tester) async {
            await tester.tap(find.text(t.backup.actions.create));
            await tester.pumpAndSettle();
          },
        );
      });

      testWidgets('renders a restore before its progress with '
          '${variant.suffix}', (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const BackupPage(),
          'backup_page_restoring',
          variant: variant,
          overrides: [
            backupControllerProvider.overrideWithValue(
              _FakeBackupController(),
            ),
          ],
          act: (tester) async {
            await tester.tap(find.text(t.backup.actions.restore));
            // The progress indicator moves until the restore reports its
            // progress, so the frames never settle.
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 500));
          },
        );
      });

      testWidgets('renders the confirmation of an old backup with '
          '${variant.suffix}', (tester) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const BackupPage(),
          'backup_page_legacy_restore',
          variant: variant,
          overrides: [
            backupControllerProvider.overrideWithValue(
              _FakeBackupController(isLegacy: true),
            ),
          ],
          act: (tester) async {
            await tester.tap(find.text(t.backup.actions.restore));
            await tester.pumpAndSettle();
          },
        );
      });

      testWidgets('renders a completed restore with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          const BackupPage(),
          'backup_page_restored',
          variant: variant,
          overrides: [
            backupControllerProvider.overrideWithValue(
              _FakeBackupController(restoreCompletes: true),
            ),
          ],
          act: (tester) async {
            await tester.tap(find.text(t.backup.actions.restore));
            await tester.pumpAndSettle();
            await GoldenTestHelpers.loadImages(tester);
          },
        );
      });
    }
  });
}
