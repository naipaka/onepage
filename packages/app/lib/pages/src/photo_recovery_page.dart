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
import '../../gen/assets.gen.dart';
import '../../router/router.dart';
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
    final recovery = ref.read(photoRecoveryProvider.notifier);
    final option = ref.watch(devicePhotoAccessOptionProvider).value;
    final devicePhotos = ref.watch(devicePhotosProvider);
    final images = ref.watch(externalDiaryImagesProvider).value ?? [];
    final dismissed = ref.watch(photoRecoveryDismissedProvider);

    Future<void> showSettingsDialog() async {
      final result = await showOkCancelAlertDialog(
        context: context,
        title: t.photoRecovery.settings.title,
        message: t.photoRecovery.settings.message,
        okLabel: t.photoRecovery.settings.action,
      );
      if (result == OkCancelResult.ok) {
        await devicePhotos.openSettings();
      }
    }

    Future<void> recoverFromDevice() async {
      final request = await devicePhotos.requestAccess();
      switch (request) {
        case DevicePhotoAccessRequest.allowed:
          await recovery.recoverFromDevice();
        case DevicePhotoAccessRequest.unavailable:
          await showSettingsDialog();
        case DevicePhotoAccessRequest.declined:
          return;
      }
    }

    Future<void> recoverRequested() async {
      try {
        final recovered = await recovery.recoverRequested();
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
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Center(
              child: Assets.images.restoredBackup.image(
                width: 140,
                height: 140,
              ),
            ),
            const Gap(12),
            if (status != null) ...[
              TitleLargeText(
                t.photoRecovery.progress,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
              ),
              const Gap(24),
              LinearProgressIndicator(
                value: status.total == 0
                    ? null
                    : status.completed / status.total,
              ),
              const Gap(8),
              BodySmallText(
                t.photoRecovery.progressCount(
                  completed: status.completed,
                  total: status.total,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (images.isEmpty) ...[
              TitleLargeText(
                t.photoRecovery.done.title,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
              ),
              const Gap(12),
              BodyMediumText(
                t.photoRecovery.done.message,
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              HapticFilledButton(
                onPressed: () => const HomeRouteData().go(context),
                child: Text(t.photoRecovery.done.action),
              ),
            ] else
              ...switch (option) {
                null => [centerLoadingIndicator],
                DevicePhotoAccessOption.none => [
                  TitleLargeText(
                    t.photoRecovery.notFound(count: images.length),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                  const Gap(20),
                  _Point(
                    icon: Icons.smartphone_outlined,
                    text: t.photoRecovery.savedInApp,
                  ),
                  const Gap(12),
                  _Point(
                    icon: Icons.hide_image_outlined,
                    text: t.photoRecovery.deletedFromDevice,
                  ),
                  const Gap(32),
                  OutlinedButton(
                    onPressed: deleteUnrecovered,
                    child: Text(t.photoRecovery.deleteUnrecovered.action),
                  ),
                ],
                DevicePhotoAccessOption.requestPhotos ||
                DevicePhotoAccessOption.openSettings => [
                  TitleLargeText(
                    t.photoRecovery.notShown(count: images.length),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                  const Gap(20),
                  _Point(
                    icon: Icons.smartphone_outlined,
                    text: t.photoRecovery.savedInApp,
                  ),
                  const Gap(12),
                  _Point(
                    icon: Icons.photo_outlined,
                    text: t.photoRecovery.shownAfterRecovery,
                  ),
                  const Gap(32),
                  HapticFilledButton(
                    onPressed: option == DevicePhotoAccessOption.requestPhotos
                        ? recoverRequested
                        : recoverFromDevice,
                    child: Text(t.photoRecovery.action),
                  ),
                  const Gap(24),
                  const Divider(height: 1),
                  const Gap(12),
                  TextButton(
                    onPressed: deleteUnrecovered,
                    child: Text(t.photoRecovery.deleteUnrecovered.action),
                  ),
                  if (!dismissed)
                    TextButton(
                      onPressed: dismiss,
                      child: Text(t.photoRecovery.dismiss.action),
                    ),
                ],
              },
            if (status == null && imageId != null) ...[
              const Gap(12),
              TextButton(
                onPressed: () => deletePhoto(imageId!),
                child: Text(t.photoRecovery.deletePhoto),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// {@template photo_recovery_page._Point}
/// A short fact about the recovery, shown with an icon.
/// {@endtemplate}
class _Point extends StatelessWidget {
  /// {@macro photo_recovery_page._Point}
  const new({required this.icon, required this.text});

  /// The icon shown before the text.
  final IconData icon;

  /// The fact to show.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: context.colorScheme.secondary),
        const Gap(12),
        Expanded(child: BodyMediumText(text)),
      ],
    );
  }
}
