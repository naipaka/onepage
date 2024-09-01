import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/pages.dart';

part 'app_routes.g.dart';

/// Home route data.
@TypedGoRoute<HomeRouteData>(
  path: HomeRouteData.path,
)
class HomeRouteData extends GoRouteData {
  /// Creates the home route data constructor.
  const HomeRouteData();

  /// The home route path.
  static const String path = '/';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
