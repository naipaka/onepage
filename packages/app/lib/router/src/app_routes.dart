import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/pages.dart';

part 'app_routes.g.dart';

/// {@template onepage.HomeRouteData}
/// Home route data.
/// {@endtemplate}
@TypedGoRoute<HomeRouteData>(
  path: HomeRouteData.path,
  routes: [
    TypedGoRoute<LicenseRouteData>(path: LicenseRouteData.path),
    TypedGoRoute<BackupRouteData>(path: BackupRouteData.path),
  ],
)
class HomeRouteData extends GoRouteData with _$HomeRouteData {
  /// {@macro onepage.HomeRouteData}
  const HomeRouteData();

  /// The home route path.
  static const path = '/';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

/// {@template onepage.LicenseRouteData}
/// License route data.
/// {@endtemplate}
class LicenseRouteData extends GoRouteData with _$LicenseRouteData {
  /// {@macro onepage.LicenseRouteData}
  const LicenseRouteData();

  /// The license route path.
  static const path = 'license';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppLicensePage();
  }
}

/// {@template onepage.BackupRouteData}
/// Backup route data.
/// {@endtemplate}
class BackupRouteData extends GoRouteData with _$BackupRouteData {
  /// {@macro onepage.BackupRouteData}
  const BackupRouteData();

  /// The backup route path.
  static const path = 'backup';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BackupPage();
  }
}
