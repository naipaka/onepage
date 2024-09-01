import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/update_request/update_request.dart';
import 'providers/providers.dart';
import 'router/router.dart';
import 'theme/theme.dart';
import 'widgets/widgets.dart';

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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
