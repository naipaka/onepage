import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// A view that shows a dialog to request an update.
class UpdateRequestView extends StatelessWidget {
  /// Creates the [UpdateRequestView].
  const UpdateRequestView({
    super.key,
    required this.message,
  });

  /// The message to show in the dialog.
  final String message;

  @override
  Widget build(BuildContext context) {
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
            onPressed: () async {
              final platform = defaultTargetPlatform;
              final urlString = switch (platform) {
                // TODO(naipaka): Add the URL for the play store.
                TargetPlatform.android => '',
                // TODO(naipaka): Add the URL for the app store.
                TargetPlatform.iOS => '',
                _ => throw UnsupportedError(
                    'Unsupported platform: $platform',
                  ),
              };
              final url = Uri.https(urlString);
              if (await canLaunchUrl(url)) {
                unawaited(launchUrl(url));
              }
            },
            child: Text(t.button.updateNow),
          ),
        ],
      ),
    );
  }
}
