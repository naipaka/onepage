import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/pages.dart';

part 'app_routes.g.dart';

/// Home route data.
@TypedGoRoute<HomeRouteData>(
  path: HomeRouteData.path,
  routes: [
    TypedGoRoute<LicenseRouteData>(
      path: LicenseRouteData.path,
    ),
  ],
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

/// License route data.
class LicenseRouteData extends GoRouteData {
  /// Creates the license route data constructor.
  const LicenseRouteData();

  /// The license route path.
  static const String path = 'license';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppLicensePage();
  }
}
