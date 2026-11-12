import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:backup/backup.dart';
import 'package:flutter/foundation.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';
import '../../gen/assets.gen.dart';
import '../../router/router.dart';
import '../../widgets/widgets.dart';

/// {@template backup_page}
/// A page that allows the user to back up their data.
/// {@endtemplate}
class BackupPage extends ConsumerWidget {
  /// {@macro backup_page}
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final controller = ref.watch(backupControllerProvider);
    final haptics = ref.watch(hapticsProvider);

    Future<void> runWithProgress({
      required String title,
      required Future<void> Function(BackupProgressCallback onProgress) task,
    }) async {
      final progress = ValueNotifier<(int, int)?>(null);
      final navigator = Navigator.of(context, rootNavigator: true);
      unawaited(
        _BackupProgressDialog.show(context, title: title, progress: progress),
      );
      try {
        await task((completed, total) => progress.value = (completed, total));
      } finally {
        navigator.pop();
        progress.dispose();
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.backup.title)),
      body: SafeArea(
        // Using [LayoutBuilder] and [ConstrainedBox] to achieve:
        // - Content is centered when scrolling is not needed
        // - Container becomes scrollable when scrolling is required
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Assets.images.backup.image(width: 200, height: 200),
                    TitleLargeText(t.backup.description),
                    const _Divider(),
                    // Create backup.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: BodyLargeText(
                        t.backup.explanation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(24),
                    HapticFilledButton(
                      onPressed: () async {
                        try {
                          await runWithProgress(
                            title: t.backup.progress.creating,
                            task: (onProgress) => controller.createBackupFile(
                              onProgress: onProgress,
                            ),
                          );
                          if (!context.mounted) {
                            return;
                          }
                          haptics.successFeedback();
                          showSuccessToast(
                            context,
                            title: t.backup.successMessage,
                            icon: const Icon(Icons.backup_outlined),
                          );
                        } on Object catch (e) {
                          final tracker = ref.read(trackerProvider);
                          unawaited(
                            tracker.recordError(
                              e,
                              StackTrace.current,
                              fatal: true,
                            ),
                          );
                          showErrorToast(
                            context,
                            title: t.backup.failedMessage,
                          );
                        }
                      },
                      child: Text(t.backup.actions.create),
                    ),
                    const _Divider(),
                    // Restore backup.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: BodyLargeText(
                        t.backup.restoreExplanation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(24),
                    HapticFilledButton(
                      onPressed: () async {
                        try {
                          ref.showLoading();
                          final backupFile = await controller.pickBackupFile();
                          if (backupFile == null) {
                            // User canceled the file picker.
                            return;
                          }

                          if (backupFile.isLegacy) {
                            if (!context.mounted) {
                              return;
                            }
                            ref.hideLoading();
                            final result = await showOkCancelAlertDialog(
                              context: context,
                              title: t.backup.legacyRestore.title,
                              message: t.backup.legacyRestore.message,
                              okLabel: t.backup.legacyRestore.confirm,
                              cancelLabel: t.backup.legacyRestore.cancel,
                            );
                            if (result != OkCancelResult.ok) {
                              return;
                            }
                          }
                          ref.hideLoading();
                          if (!context.mounted) {
                            return;
                          }

                          // A paused stream keeps the database from closing.
                          ref.invalidate(diaryImageCountProvider);
                          await runWithProgress(
                            title: t.backup.progress.restoring,
                            task: (onProgress) => controller.restoreBackupFile(
                              backupFile,
                              onProgress: onProgress,
                            ),
                          ).whenComplete(
                            // restoreBackupFile closes the client even when
                            // it fails.
                            () => ref.invalidate(dbClientProvider),
                          );

                          if (!context.mounted) {
                            return;
                          }
                          haptics.successFeedback();
                          // Using unawaited to display the dialog
                          // while handling the loading indicator dismissal.
                          unawaited(_BackupRestoreDialog.show(context));
                        } on Object catch (e) {
                          final tracker = ref.read(trackerProvider);
                          unawaited(
                            tracker.recordError(
                              e,
                              StackTrace.current,
                              fatal: true,
                            ),
                          );
                          if (context.mounted) {
                            showErrorToast(
                              context,
                              title: t.backup.restoreFailedMessage,
                            );
                          }
                        } finally {
                          ref.hideLoading();
                        }
                      },
                      child: Text(t.backup.actions.restore),
                    ),
                    const Gap(48),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      width: 100,
      child: Divider(
        height: 0,
        color: context.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}

class _BackupProgressDialog extends StatelessWidget {
  const new({required this.title, required this.progress});

  final String title;
  final ValueListenable<(int, int)?> progress;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required ValueListenable<(int, int)?> progress,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _BackupProgressDialog(title: title, progress: progress),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ValueListenableBuilder(
            valueListenable: progress,
            builder: (context, value, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleMediumText(title, textAlign: TextAlign.center),
                  const Gap(24),
                  LinearProgressIndicator(
                    value: value == null ? null : value.$1 / value.$2,
                  ),
                  if (value != null) ...[
                    const Gap(12),
                    BodyMediumText('${value.$1} / ${value.$2}'),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BackupRestoreDialog extends StatelessWidget {
  const new();

  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _BackupRestoreDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.restoredBackup.image(width: 160, height: 160),
              TitleMediumText(
                t.backup.restoreSuccess,
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              HapticFilledButton(
                onPressed: () {
                  const HomeRouteData().replace(context);
                  Navigator.pop(context);
                },
                child: Text(t.backup.actions.goToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
