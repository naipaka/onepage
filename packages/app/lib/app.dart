import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';
import 'package:update_requester/update_requester.dart';
import 'package:widgets/widgets.dart';

import 'adapters/update_requester_provider.dart';
import 'router/router.dart';

/// The main application widget.
class App extends ConsumerWidget {
  /// Creates the main application widget.
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
        final colors = context.colors;
        return Stack(
          children: [
            if (child case final Widget child) child,
            // Show the loading indicator if the loading state is true.
            Consumer(
              builder: (context, ref, child) {
                if (ref.watch(isLoadingProvider)) {
                  return ColoredBox(
                    color: colors.overlay!,
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
                  color: colors.overlay!,
                  child: UpdateRequestView(message: message),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
