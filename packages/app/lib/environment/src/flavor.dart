/// Flavor enums.
enum Flavor {
  /// Development flavor.
  dev,

  /// Production flavor.
  prod;

  /// The flavor the app is built with.
  static Flavor get current =>
      Flavor.values.byName(const String.fromEnvironment('flavor'));
}
