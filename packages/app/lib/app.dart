import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';
import 'package:update_requester/update_requester.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import 'adapters/adapters.dart';
import 'router/router.dart';

/// {@template onepage.App}
/// The main application widget.
/// {@endtemplate}
class App extends ConsumerWidget {
  /// {@macro onepage.App}
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      routerConfig: router,
      locale: context.locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      builder: (context, child) {
        final colorScheme = context.colorScheme;
        return Stack(
          children: [
            if (child case final Widget child) child,
            // Show the loading indicator if the loading state is true.
            Consumer(
              builder: (context, ref, child) {
                if (ref.watch(isLoadingProvider)) {
                  return ColoredBox(
                    color: colorScheme.scrim,
                    child: const PopScope(
                      canPop: false,
                      child: centerLoadingIndicator,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Show the update request dialog if the message is not null.
            Consumer(
              builder: (context, ref, child) {
                final message = ref.watch(updateRequestMessageProvider);
                if (message == null) {
                  return const SizedBox.shrink();
                }
                return ColoredBox(
                  color: colorScheme.scrim,
                  child: UpdateRequestView(
                    title: t.updateRequest.title,
                    message: message,
                    buttonText: t.updateRequest.button.updateNow,
                    onButtonPressed: () async {
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
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
