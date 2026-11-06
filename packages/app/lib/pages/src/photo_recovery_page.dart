import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';
import '../../widgets/widgets.dart';

/// {@template photo_recovery_page}
/// A page that recovers photos saved on the device.
/// {@endtemplate}
class PhotoRecoveryPage extends ConsumerWidget {
  /// {@macro photo_recovery_page}
  const new({super.key, this.imageId});

  /// The diary image the page was opened from.
  final int? imageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final recovery = ref.watch(photoRecoveryProvider);
    final notifier = ref.read(photoRecoveryProvider.notifier);
    final images = ref.watch(unmigratedDiaryImagesProvider).value ?? [];
    final dismissed = ref.watch(prefsClientProvider).photoRecoveryDismissed;
    final progress = recovery.progress;

    Future<void> recoverFromFolder() async {
      try {
        final recovered = await notifier.importFromFolder();
        if (recovered != null && context.mounted) {
          showSuccessToast(
            context,
            title: t.photoRecovery.recovered(count: recovered),
            icon: const Icon(Icons.photo_library_outlined),
          );
        }
      } on Object catch (e, stackTrace) {
        await ref.read(trackerProvider).recordError(e, stackTrace);
        if (context.mounted) {
          showErrorToast(context, title: t.photoRecovery.failed);
        }
      }
    }

    Future<void> dismiss() async {
      final result = await showOkCancelAlertDialog(
        context: context,
        title: t.photoRecovery.dismiss.title,
        message: t.photoRecovery.dismiss.message,
      );
      if (result == OkCancelResult.ok) {
        await notifier.dismiss();
      }
    }

    Future<void> deletePhoto(int id) async {
      final result = await showOkCancelAlertDialog(
        context: context,
        title: t.photoRecovery.deleteConfirm.title,
        message: t.photoRecovery.deleteConfirm.message,
      );
      if (result != OkCancelResult.ok) {
        return;
      }
      await ref.read(cachedDiariesProvider.notifier).deleteImage(imageId: id);
      ref.invalidate(unmigratedDiaryImagesProvider);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.photoRecovery.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TitleMediumText(
              t.photoRecovery.remaining(count: images.length),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            if (progress != null) ...[
              BodyLargeText(
                t.photoRecovery.progress,
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              LinearProgressIndicator(
                value: progress.$2 == 0 ? null : progress.$1 / progress.$2,
              ),
            ] else if (images.isNotEmpty)
              ...switch (recovery.action) {
                PhotoRecoveryAction.pickFolder => [
                  BodyLargeText(t.photoRecovery.folder.message),
                  const Gap(24),
                  HapticFilledButton(
                    onPressed: recoverFromFolder,
                    child: Text(t.photoRecovery.folder.action),
                  ),
                ],
                PhotoRecoveryAction.openSettings => [
                  BodyLargeText(t.photoRecovery.settings.message),
                  const Gap(24),
                  HapticFilledButton(
                    onPressed: ref.read(photoLibraryProvider).openSettings,
                    child: Text(t.photoRecovery.settings.action),
                  ),
                  const Gap(12),
                  TextButton(
                    onPressed: () => notifier.importFromLibrary(retry: true),
                    child: Text(t.photoRecovery.settings.retry),
                  ),
                ],
                PhotoRecoveryAction.none => [
                  BodyLargeText(t.photoRecovery.missing),
                ],
                PhotoRecoveryAction.unknown => [centerLoadingIndicator],
              },
            if (progress == null && imageId != null) ...[
              const Gap(24),
              OutlinedButton(
                onPressed: () => deletePhoto(imageId!),
                child: Text(t.photoRecovery.deletePhoto),
              ),
            ],
            if (progress == null &&
                images.isNotEmpty &&
                !dismissed &&
                recovery.action != PhotoRecoveryAction.none) ...[
              const Gap(24),
              TextButton(
                onPressed: dismiss,
                child: Text(t.photoRecovery.dismiss.action),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
