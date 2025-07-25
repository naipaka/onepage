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
    TypedGoRoute<NotificationsRouteData>(
      path: NotificationsRouteData.path,
    ),
    TypedGoRoute<BackupRouteData>(
      path: BackupRouteData.path,
    ),
    TypedGoRoute<ExportRouteData>(
      path: ExportRouteData.path,
    ),
    TypedGoRoute<SettingsRouteData>(
      path: SettingsRouteData.path,
      routes: [
        TypedGoRoute<HapticFeedbackRouteData>(
          path: HapticFeedbackRouteData.path,
        ),
      ],
    ),
    TypedGoRoute<LicenseRouteData>(
      path: LicenseRouteData.path,
    ),
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

/// {@template onepage.NotificationsRouteData}
/// Notifications route data.
/// {@endtemplate}
class NotificationsRouteData extends GoRouteData with _$NotificationsRouteData {
  /// {@macro onepage.NotificationsRouteData}
  const NotificationsRouteData();

  /// The notifications route path.
  static const path = 'notifications';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationsPage();
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

/// {@template onepage.ExportRouteData}
/// Export route data.
/// {@endtemplate}
class ExportRouteData extends GoRouteData with _$ExportRouteData {
  /// {@macro onepage.ExportRouteData}
  const ExportRouteData();

  /// The export route path.
  static const path = 'export';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ExportPage();
  }
}

/// {@template onepage.SettingsRouteData}
/// Settings route data.
/// {@endtemplate}
class SettingsRouteData extends GoRouteData with _$SettingsRouteData {
  /// {@macro onepage.SettingsRouteData}
  const SettingsRouteData();

  /// The settings route path.
  static const path = 'settings';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}

/// {@template onepage.HapticFeedbackRouteData}
/// Haptic feedback route data.
/// {@endtemplate}
class HapticFeedbackRouteData extends GoRouteData
    with _$HapticFeedbackRouteData {
  /// {@macro onepage.HapticFeedbackRouteData}
  const HapticFeedbackRouteData();

  /// The haptic feedback route path.
  static const path = 'haptic-feedback';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HapticFeedbackPage();
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
