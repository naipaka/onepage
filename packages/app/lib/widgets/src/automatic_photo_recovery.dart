import 'dart:async';

import 'package:device_photos/device_photos.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';
import '../../router/router.dart';

/// {@template onepage.AutomaticPhotoRecovery}
/// Recovers photos automatically for each database, and reminds the user
/// about the photos that remain.
/// {@endtemplate}
class AutomaticPhotoRecovery extends HookConsumerWidget {
  /// {@macro onepage.AutomaticPhotoRecovery}
  const new({super.key, required this.child});

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbClient = ref.watch(dbClientProvider);

    Future<void> recoverAndRemind() async {
      final recovery = ref.read(photoRecoveryProvider.notifier);
      await recovery.recoverFromDevice();
      final diaryQuery = ref.read(diaryQueryProvider);
      final images = await diaryQuery.getExternalDiaryImages();
      final devicePhotos = ref.read(devicePhotosProvider);
      final option = await devicePhotos.accessOption([
        for (final image in images) image.photoId!,
      ]);
      final dismissed = ref.read(photoRecoveryDismissedProvider);
      if (images.isEmpty ||
          dismissed ||
          option == DevicePhotoAccessOption.none ||
          !context.mounted) {
        return;
      }
      final t = context.t;
      showActionSnackBar(
        context,
        message: t.photoRecovery.banner,
        actionLabel: t.photoRecovery.remind,
        onAction: () {
          ref.read(routerProvider).go(const PhotoRecoveryRouteData().location);
        },
      );
    }

    // Runs for each database, so that restored photos are recovered too.
    useEffect(() {
      // Riverpod does not allow changing a provider during a build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          unawaited(recoverAndRemind());
        }
      });
      return null;
    }, [dbClient]);

    return child;
  }
}
