import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: $appRoutes,
    observers: [
      ...tracker.navigatorObservers(
        nameExtractor: (settings) {
          debugPrint('🚀nameExtractor: ${settings.name}');
          return settings.name ?? 'unknown';
        },
      ),
    ],
    initialLocation: HomeRouteData.path,
  );
}
