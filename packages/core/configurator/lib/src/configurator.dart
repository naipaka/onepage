import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'config.dart';

/// Callback function type for value change notifications.
typedef _ValueChanged<T> = void Function(T value);

/// A wrapper for Firebase Remote Config that simplifies configuration
/// management.
///
/// This class provides a high-level interface for retrieving configuration
/// values from Firebase Remote Config with type safety and automatic value
/// conversion. It supports real-time configuration updates through reactive
/// Config objects.
class Configurator {
  /// Creates a Configurator instance using the default Firebase Remote
  /// Config.
  Configurator() : _rc = FirebaseRemoteConfig.instance;

  /// Creates a Configurator instance for testing with a custom RemoteConfig.
  @visibleForTesting
  Configurator.forTesting(FirebaseRemoteConfig rc) : _rc = rc;

  final FirebaseRemoteConfig _rc;

  /// Fetches the latest configuration values and activates them.
  ///
  /// Returns true if the fetch was successful and new values were activated,
  /// false otherwise.
  Future<bool> fetchAndActivate() async {
    return _rc.fetchAndActivate();
  }

  /// Activates the most recently fetched configuration values.
  ///
  /// Returns true if values were activated, false otherwise.
  Future<bool> activate() async {
    return _rc.activate();
  }

  /// Configures the Remote Config settings.
  ///
  /// Parameters:
  ///   [fetchTimeout] - Maximum time to wait for a fetch request.
  ///   [minimumFetchInterval] - Minimum interval between fetch requests.
  Future<void> configure({
    required Duration fetchTimeout,
    required Duration minimumFetchInterval,
  }) async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
  }

  /// Sets default parameter values.
  ///
  /// The [defaultParameters] map should contain values of type String, int,
  /// double, or bool only.
  Future<void> setDefaults(Map<String, Object?> defaultParameters) async {
    for (final p in defaultParameters.values) {
      assert(p is String || p is int || p is double || p is bool);
    }
    await _rc.setDefaults(defaultParameters);
  }

  /// Stream of configuration update events.
  ///
  /// This stream emits events when the Remote Config values are updated.
  @visibleForTesting
  late final Stream<RemoteConfigUpdate> onConfigUpdated = _rc.onConfigUpdated;

  /// Returns a filtered stream of configuration updates for a specific key.
  ///
  /// Only emits events when the specified [key] has been updated.
  Stream<RemoteConfigUpdate> filteredOnConfigUpdated(String key) {
    return onConfigUpdated.where((config) => config.updatedKeys.contains(key));
  }

  /// Retrieves a string value for the given key.
  @visibleForTesting
  String getString(String key) {
    final value = _rc.getString(key);
    return value;
  }

  /// Retrieves an integer value for the given key.
  @visibleForTesting
  int getInt(String key) {
    final value = _rc.getInt(key);
    return value;
  }

  /// Retrieves a double value for the given key.
  @visibleForTesting
  double getDouble(String key) {
    final value = _rc.getDouble(key);
    return value;
  }

  /// Retrieves a boolean value for the given key.
  @visibleForTesting
  bool getBool(String key) {
    final value = _rc.getBool(key);
    return value;
  }

  /// Retrieves a JSON object for the given key.
  ///
  /// The JSON string is automatically decoded into a Map.
  @visibleForTesting
  Map<String, Object?> getJson(String key) {
    final value = _rc.getString(key);
    return json.decode(value) as Map<String, dynamic>;
  }

  /// Retrieves a list of JSON objects for the given key.
  ///
  /// The JSON string is automatically decoded into a List of Maps.
  @visibleForTesting
  List<Map<String, Object?>> getListJson(String key) {
    final value = _rc.getString(key);
    final list = json.decode(value) as List<dynamic>;
    return list.map((dynamic e) => e as Map<String, Object?>).toList();
  }

  /// Retrieves typed data for the given key using a fromJson converter.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [fromJson] - Function to convert JSON map to the desired type.
  @visibleForTesting
  T getData<T extends Object>({
    required String key,
    required T Function(Map<String, Object?>) fromJson,
  }) {
    final json = getJson(key);
    return fromJson(json);
  }

  /// Creates a reactive Config object for string values.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [onConfigUpdated] - Optional callback for real-time updates.
  Config<String> getStringConfig(
    String key, {
    _ValueChanged<String>? onConfigUpdated,
  }) {
    return Config<String>(
      value: getString(key),
      subscription: kIsWeb || onConfigUpdated == null
          ? null
          : filteredOnConfigUpdated(key).listen((event) async {
              await activate();
              onConfigUpdated(getString(key));
            }),
    );
  }

  /// Creates a reactive Config object for integer values.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [onConfigUpdated] - Optional callback for real-time updates.
  Config<int> getIntConfig(String key, {_ValueChanged<int>? onConfigUpdated}) {
    return Config<int>(
      value: getInt(key),
      subscription: kIsWeb || onConfigUpdated == null
          ? null
          : filteredOnConfigUpdated(key).listen((event) async {
              await activate();
              onConfigUpdated(getInt(key));
            }),
    );
  }

  /// Creates a reactive Config object for double values.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [onConfigUpdated] - Optional callback for real-time updates.
  Config<double> getDoubleConfig(
    String key, {
    _ValueChanged<double>? onConfigUpdated,
  }) {
    return Config<double>(
      value: getDouble(key),
      subscription: kIsWeb || onConfigUpdated == null
          ? null
          : filteredOnConfigUpdated(key).listen((event) async {
              await activate();
              onConfigUpdated(getDouble(key));
            }),
    );
  }

  /// Creates a reactive Config object for boolean values.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [onConfigUpdated] - Optional callback for real-time updates.
  Config<bool> getBoolConfig(
    String key, {
    _ValueChanged<bool>? onConfigUpdated,
  }) {
    return Config<bool>(
      value: getBool(key),
      subscription: kIsWeb || onConfigUpdated == null
          ? null
          : filteredOnConfigUpdated(key).listen((event) async {
              await activate();
              onConfigUpdated(getBool(key));
            }),
    );
  }

  /// Creates a reactive Config object for JSON values.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [onConfigUpdated] - Optional callback for real-time updates.
  Config<Map<String, Object?>> getJsonConfig(
    String key, {
    _ValueChanged<Map<String, Object?>>? onConfigUpdated,
  }) {
    return Config<Map<String, Object?>>(
      value: getJson(key),
      subscription: kIsWeb || onConfigUpdated == null
          ? null
          : filteredOnConfigUpdated(key).listen((event) async {
              await activate();
              onConfigUpdated(getJson(key));
            }),
    );
  }

  /// Creates a reactive Config object for list JSON values.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [onConfigUpdated] - Optional callback for real-time updates.
  Config<List<Map<String, Object?>>> getListJsonConfig(
    String key, {
    _ValueChanged<List<Map<String, Object?>>>? onConfigUpdated,
  }) {
    return Config<List<Map<String, Object?>>>(
      value: getListJson(key),
      subscription: kIsWeb || onConfigUpdated == null
          ? null
          : filteredOnConfigUpdated(key).listen((event) async {
              await activate();
              onConfigUpdated(getListJson(key));
            }),
    );
  }

  /// Creates a reactive Config object for typed data.
  ///
  /// Parameters:
  ///   [key] - The configuration key to retrieve.
  ///   [fromJson] - Function to convert JSON map to the desired type.
  ///   [onConfigUpdated] - Optional callback for real-time updates.
  Config<T> getDataConfig<T extends Object>(
    String key, {
    required T Function(Map<String, Object?>) fromJson,
    _ValueChanged<T>? onConfigUpdated,
  }) {
    return Config<T>(
      value: getData<T>(key: key, fromJson: fromJson),
      subscription: kIsWeb || onConfigUpdated == null
          ? null
          : filteredOnConfigUpdated(key).listen((event) async {
              await activate();
              onConfigUpdated(getData(key: key, fromJson: fromJson));
            }),
    );
  }
}
