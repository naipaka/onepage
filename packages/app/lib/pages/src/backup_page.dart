import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
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
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final controller = ref.watch(backupControllerProvider);
    final haptics = ref.watch(hapticsProvider);
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
                          ref.showLoading();
                          // Delay to show loading indicator.
                          await Future<void>.delayed(
                            const Duration(milliseconds: 1000),
                          );
                          await controller.createBackupFile();
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
                        } finally {
                          ref.hideLoading();
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
                          final filePath = await controller.restoreBackupFile();
                          if (filePath == null) {
                            // User canceled the file picker.
                            return;
                          }

                          // DB client is closed to avoid conflicts with
                          // the current backup process.
                          await ref.read(dbClientProvider).close();
                          ref.invalidate(dbClientProvider);

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
                          showErrorToast(
                            context,
                            title: t.backup.restoreFailedMessage,
                          );
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
  const _Divider();

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

class _BackupRestoreDialog extends StatelessWidget {
  const _BackupRestoreDialog();

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
