import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme/theme.dart';

import 'pages/src/initialization_page.dart';
import 'router/router.dart';

/// {@template onepage.App}
/// The main application widget.
/// {@endtemplate}
class App extends ConsumerWidget {
  /// {@macro onepage.App}
  const new({super.key});

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
        // toastification reads the theme from package:flutter/material.dart.
        // Remove the bridge when the app's own toast replaces toastification.
        // ignore: deprecated_member_use
        return MaterialUiCompatibilityBridge(
          child: InitializationPage(onInitialized: (_) => child),
        );
      },
    );
  }
}
