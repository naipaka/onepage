// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRouteData];

RouteBase get $homeRouteData => GoRouteData.$route(
  path: '/',

  factory: $HomeRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: 'license',

      factory: $LicenseRouteDataExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'backup',

      factory: $BackupRouteDataExtension._fromState,
    ),
  ],
);

extension $HomeRouteDataExtension on HomeRouteData {
  static HomeRouteData _fromState(GoRouterState state) => const HomeRouteData();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LicenseRouteDataExtension on LicenseRouteData {
  static LicenseRouteData _fromState(GoRouterState state) =>
      const LicenseRouteData();

  String get location => GoRouteData.$location('/license');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BackupRouteDataExtension on BackupRouteData {
  static BackupRouteData _fromState(GoRouterState state) =>
      const BackupRouteData();

  String get location => GoRouteData.$location('/backup');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
