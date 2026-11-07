import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:device_photos/device_photos.dart';
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
    final status = ref.watch(photoRecoveryProvider);
    final notifier = ref.read(photoRecoveryProvider.notifier);
    final option = ref.watch(devicePhotoAccessOptionProvider).value;
    final devicePhotos = ref.watch(devicePhotosProvider);
    final images = ref.watch(externalDiaryImagesProvider).value ?? [];
    final dismissed = ref.watch(photoRecoveryDismissedProvider);

    Future<void> recoverFromFolder() async {
      try {
        final recovered = await notifier.recoverFromFolder();
        if (recovered != null && context.mounted) {
          showSuccessToast(
            context,
            title: t.photoRecovery.recovered(count: recovered),
            icon: const Icon(Icons.photo_library_outlined),
          );
        }
      } on Object catch (e, stackTrace) {
        final tracker = ref.read(trackerProvider);
        unawaited(tracker.recordError(e, stackTrace));
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
        final dismissal = ref.read(photoRecoveryDismissedProvider.notifier);
        await dismissal.dismiss();
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
      final diaries = ref.read(cachedDiariesProvider.notifier);
      await diaries.deleteImage(imageId: id);
      ref.invalidate(externalDiaryImagesProvider);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    Future<void> deleteUnrecovered() async {
      final result = await showOkCancelAlertDialog(
        context: context,
        title: t.photoRecovery.deleteUnrecovered.title,
        message: t.photoRecovery.deleteUnrecovered.message(
          count: images.length,
        ),
      );
      if (result != OkCancelResult.ok) {
        return;
      }
      final diaries = ref.read(cachedDiariesProvider.notifier);
      await diaries.deleteExternalImages();
      ref.invalidate(externalDiaryImagesProvider);
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
            if (status != null) ...[
              BodyLargeText(
                t.photoRecovery.progress,
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              LinearProgressIndicator(
                value: status.total == 0
                    ? null
                    : status.completed / status.total,
              ),
            ] else if (images.isNotEmpty)
              ...switch (option) {
                DevicePhotoAccessOption.selectFolder => [
                  BodyLargeText(t.photoRecovery.folder.message),
                  const Gap(24),
                  HapticFilledButton(
                    onPressed: recoverFromFolder,
                    child: Text(t.photoRecovery.folder.action),
                  ),
                ],
                DevicePhotoAccessOption.openSettings => [
                  BodyLargeText(t.photoRecovery.settings.message),
                  const Gap(24),
                  HapticFilledButton(
                    onPressed: devicePhotos.openSettings,
                    child: Text(t.photoRecovery.settings.action),
                  ),
                  const Gap(12),
                  TextButton(
                    onPressed: notifier.recoverFromDevice,
                    child: Text(t.photoRecovery.settings.retry),
                  ),
                ],
                DevicePhotoAccessOption.none => [
                  BodyLargeText(t.photoRecovery.missing),
                ],
                null => [centerLoadingIndicator],
              },
            if (status == null && images.isNotEmpty && option != null) ...[
              const Gap(12),
              TextButton(
                onPressed: deleteUnrecovered,
                child: Text(t.photoRecovery.deleteUnrecovered.action),
              ),
            ],
            if (status == null && imageId != null) ...[
              const Gap(24),
              OutlinedButton(
                onPressed: () => deletePhoto(imageId!),
                child: Text(t.photoRecovery.deletePhoto),
              ),
            ],
            if (status == null &&
                images.isNotEmpty &&
                !dismissed &&
                option != DevicePhotoAccessOption.none) ...[
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
