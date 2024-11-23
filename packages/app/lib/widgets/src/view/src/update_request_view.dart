import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theme/theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../i18n/localizer.dart';
import '../../../../providers/providers.dart';
import '../../../widgets.dart';

/// A view that shows a dialog to request an update.
class UpdateRequestView extends ConsumerWidget {
  /// Creates the [UpdateRequestView].
  const UpdateRequestView({
    super.key,
    required this.message,
  });

  /// The message to show in the dialog.
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t.updateRequest;
    final colors = context.colors;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: AppText.bodyLBold(
          t.title,
          color: colors.bgMain,
        ),
        content: AppText.bodyM(
          message,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              final platform = ref.read(platformProvider);
              final url = switch (platform) {
                TargetPlatform.android => '',
                TargetPlatform.iOS => '',
                _ => throw UnsupportedError(
                    'Unsupported platform: $platform',
                  ),
              };
              unawaited(launchUrlString(url));
            },
            child: Text(t.button.updateNow),
          ),
        ],
      ),
    );
  }
}
