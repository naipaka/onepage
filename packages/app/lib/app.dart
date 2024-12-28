import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';

import 'pages/src/initialization_page.dart';
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
      builder: (_, child) {
        return InitializationPage(onInitialized: (_) => child);
      },
    );
  }
}
