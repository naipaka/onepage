// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRouteData];

RouteBase get $homeRouteData => GoRouteData.$route(
  path: '/',
  factory: $HomeRouteData._fromState,
  routes: [
    GoRouteData.$route(
      path: 'notifications',
      factory: $NotificationsRouteData._fromState,
    ),
    GoRouteData.$route(path: 'backup', factory: $BackupRouteData._fromState),
    GoRouteData.$route(path: 'export', factory: $ExportRouteData._fromState),
    GoRouteData.$route(
      path: 'settings',
      factory: $SettingsRouteData._fromState,
      routes: [
        GoRouteData.$route(
          path: 'haptic-feedback',
          factory: $HapticFeedbackRouteData._fromState,
        ),
      ],
    ),
    GoRouteData.$route(path: 'license', factory: $LicenseRouteData._fromState),
  ],
);

mixin $HomeRouteData on GoRouteData {
  static HomeRouteData _fromState(GoRouterState state) => const HomeRouteData();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NotificationsRouteData on GoRouteData {
  static NotificationsRouteData _fromState(GoRouterState state) =>
      const NotificationsRouteData();

  @override
  String get location => GoRouteData.$location('/notifications');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BackupRouteData on GoRouteData {
  static BackupRouteData _fromState(GoRouterState state) =>
      const BackupRouteData();

  @override
  String get location => GoRouteData.$location('/backup');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExportRouteData on GoRouteData {
  static ExportRouteData _fromState(GoRouterState state) =>
      const ExportRouteData();

  @override
  String get location => GoRouteData.$location('/export');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRouteData on GoRouteData {
  static SettingsRouteData _fromState(GoRouterState state) =>
      const SettingsRouteData();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HapticFeedbackRouteData on GoRouteData {
  static HapticFeedbackRouteData _fromState(GoRouterState state) =>
      const HapticFeedbackRouteData();

  @override
  String get location => GoRouteData.$location('/settings/haptic-feedback');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LicenseRouteData on GoRouteData {
  static LicenseRouteData _fromState(GoRouterState state) =>
      const LicenseRouteData();

  @override
  String get location => GoRouteData.$location('/license');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
