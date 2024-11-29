import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../adapters/adapters.dart';
import 'app_routes.dart';

part 'router_provider.g.dart';

/// The root navigator key.
///
/// For example, to display a bottom sheet in front of the bottom bar,
/// you can use `rootNavigatorKey.currentContext`.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// The router provider.
@Riverpod(keepAlive: true)
Raw<GoRouter> router(Ref ref) {
  final tracker = ref.watch(trackerProvider);
  late GoRouter router;
  router = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: $appRoutes,
    observers: [
      // Used to monitor transitions that cannot be detected by routerDelegate.
      ...tracker.navigatorObservers(
        nameExtractor: (settings) {
          final config = router.routerDelegate.currentConfiguration;
          debugPrint('🚀nameExtractor: ${config.uri.path}/${settings.name}');
          return '${config.uri.path}/${settings.name}';
        },
        routeFilter: (route) {
          // Only monitor transitions made with Navigator.
          // Transitions with GoRouter are detected by routerDelegate,
          // so they are not monitored here.
          return route is MaterialPageRoute;
        },
      ),
    ],
    initialLocation: HomeRouteData.path,
  );

  // Send a screen transition event during screen transitions.
  Future<void> handleRouteChanged() async {
    final config = router.routerDelegate.currentConfiguration;
    final path = config.uri.path;
    debugPrint('🚀handleRouteChanged: $path');
    unawaited(tracker.trackScreenView(path));
  }

  router.routerDelegate.addListener(handleRouteChanged);
  ref.onDispose(() async {
    router.routerDelegate.removeListener(handleRouteChanged);
  });

  return router;
}
