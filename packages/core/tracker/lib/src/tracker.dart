import 'dart:async';
import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'trackable.dart';

/// A class that wraps a package for sending events to Analytics.
/// Its role is to "send necessary events to Analytics."
///
/// It exposes methods for sending analytic events and for configuration.
class Tracker {
  /// Create a Tracker instance.
  Tracker({
    List<Trackable> trackers = const [],
  }) : _crashlytics = FirebaseCrashlytics.instance,
       _analytics = FirebaseAnalytics.instance,
       _trackers = trackers;

  /// Create a Tracker instance for testing.
  @visibleForTesting
  Tracker.forTesting({
    required FirebaseCrashlytics crashlytics,
    required FirebaseAnalytics analytics,
    List<Trackable> trackers = const [],
  }) : _crashlytics = crashlytics,
       _analytics = analytics,
       _trackers = trackers;

  final FirebaseCrashlytics _crashlytics;
  final FirebaseAnalytics _analytics;
  final List<Trackable> _trackers;

  /// Handles Flutter framework errors.
  ///
  /// This method is called when the Flutter framework catches an error.
  /// It presents the error to the user and records it to Crashlytics.
  ///
  /// Parameters:
  ///   [flutterErrorDetails] - The error details from Flutter framework.
  ///   [fatal] - Whether the error should be marked as fatal.
  Future<void> onFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  }) async {
    FlutterError.presentError(flutterErrorDetails);
    await _crashlytics.recordFlutterError(flutterErrorDetails, fatal: fatal);
  }

  /// Handles platform errors that occur outside of Flutter.
  ///
  /// This method is called for uncaught asynchronous errors that the
  /// Flutter framework cannot catch. It records the error to Crashlytics
  /// and all custom trackers.
  ///
  /// Parameters:
  ///   [error] - The error object.
  ///   [stack] - The stack trace of the error.
  ///
  /// Returns:
  ///   Always returns true to indicate the error was handled.
  bool onPlatformError(Object error, StackTrace stack) {
    unawaited(_crashlytics.recordError(error, stack, fatal: true));
    for (final tracker in _trackers) {
      unawaited(tracker.trackError(error, stack, fatal: true));
    }
    return true;
  }

  /// Creates a SendPort for listening to isolate errors.
  ///
  /// This method returns a SendPort that can be used to receive error
  /// data from isolates. When an error is received, it records the error
  /// to Crashlytics and all custom trackers.
  ///
  /// Returns:
  ///   A SendPort for receiving isolate error data.
  SendPort isolateErrorListener() {
    return RawReceivePort((List<dynamic> pair) async {
      final errorAndStacktrace = pair;
      await Future.wait([
        _crashlytics.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last as StackTrace,
          fatal: true,
        ),
        ..._trackers.map(
          (tracker) => tracker.trackError(
            errorAndStacktrace.first,
            errorAndStacktrace.last as StackTrace,
            fatal: true,
          ),
        ),
      ]);
    }).sendPort;
  }

  /// Records an error to Crashlytics and custom trackers.
  ///
  /// This method allows manual recording of errors that are caught
  /// in application code. The error will be sent to Crashlytics
  /// and all configured custom trackers.
  ///
  /// Parameters:
  ///   [exception] - The exception or error object.
  ///   [stack] - The stack trace associated with the error.
  ///   [fatal] - Whether the error should be marked as fatal.
  Future<void> recordError(
    Object exception,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    await Future.wait([
      _crashlytics.recordError(exception, stack, fatal: fatal),
      ..._trackers.map(
        (tracker) => tracker.trackError(exception, stack, fatal: fatal),
      ),
    ]);
  }

  /// Sets the user ID for tracking purposes.
  ///
  /// This method sets the user ID in Crashlytics, Analytics,
  /// and all custom trackers. This helps associate events and
  /// errors with specific users.
  ///
  /// Parameters:
  ///   [userId] - The unique identifier for the user.
  Future<void> setUserId(String userId) async {
    await Future.wait([
      _crashlytics.setUserIdentifier(userId),
      _analytics.setUserId(id: userId),
      ..._trackers.map((tracker) => tracker.setUserId(userId)),
    ]);
  }

  /// Clears the user ID from tracking services.
  ///
  /// This method removes the user ID from Crashlytics, Analytics,
  /// and all custom trackers. This is useful when a user logs out
  /// or when you want to stop associating events with a user.
  Future<void> clearUserId() async {
    await Future.wait([
      _crashlytics.setUserIdentifier(''),
      _analytics.setUserId(),
      ..._trackers.map((tracker) => tracker.clearUserId()),
    ]);
  }

  /// Sets user properties in Analytics.
  ///
  /// This method sets user properties that can be used for
  /// analytics segmentation and reporting. Properties are
  /// key-value pairs that describe user characteristics.
  ///
  /// Parameters:
  ///   [properties] - A map of property names to values.
  Future<void> setUserProperties(Map<String, String?> properties) async {
    for (final property in properties.entries) {
      await _analytics.setUserProperty(
        name: property.key,
        value: property.value,
      );
    }
  }

  /// Creates a navigator observer for tracking screen views.
  ///
  /// This method returns a FirebaseAnalyticsObserver that can be
  /// added to your app's navigator observers to automatically
  /// track screen navigation events.
  ///
  /// Parameters:
  ///   [nameExtractor] - Function to extract screen names from routes.
  ///   [routeFilter] - Function to filter which routes to track.
  ///
  /// Returns:
  ///   A NavigatorObserver for tracking screen views.
  NavigatorObserver navigatorObserver({
    String? Function(RouteSettings) nameExtractor = defaultNameExtractor,
    bool Function(Route<dynamic>?) routeFilter = defaultRouteFilter,
  }) {
    return FirebaseAnalyticsObserver(
      analytics: _analytics,
      nameExtractor: nameExtractor,
      routeFilter: routeFilter,
    );
  }

  /// Creates a list of navigator observers for tracking screen views.
  ///
  /// This is a convenience method that returns a list containing
  /// the navigator observer for easier integration with apps that
  /// expect a list of observers.
  ///
  /// Parameters:
  ///   [nameExtractor] - Function to extract screen names from routes.
  ///   [routeFilter] - Function to filter which routes to track.
  ///
  /// Returns:
  ///   A list containing the NavigatorObserver.
  List<NavigatorObserver> navigatorObservers({
    String? Function(RouteSettings) nameExtractor = defaultNameExtractor,
    bool Function(Route<dynamic>?) routeFilter = defaultRouteFilter,
  }) {
    return [
      navigatorObserver(nameExtractor: nameExtractor, routeFilter: routeFilter),
    ];
  }

  /// Tracks a screen view event.
  ///
  /// This method logs a screen view event to Analytics and all
  /// custom trackers. Screen views help understand user navigation
  /// patterns within your app.
  ///
  /// Parameters:
  ///   [screenName] - The name of the screen being viewed.
  Future<void> trackScreenView(String screenName) async {
    await Future.wait([
      _analytics.logScreenView(screenName: screenName),
      ..._trackers.map((tracker) => tracker.trackScreenView(screenName)),
    ]);
  }

  /// Logs a custom event to Analytics and custom trackers.
  ///
  /// This method allows you to track custom events in your app.
  /// Events can include user actions, business metrics, or any
  /// other trackable occurrences.
  ///
  /// Parameters:
  ///   [eventName] - The name of the event to track.
  ///   [parameters] - Optional parameters to include with the event.
  Future<void> logEvent(
    String eventName, {
    Map<String, Object>? parameters,
  }) async {
    await Future.wait([
      _analytics.logEvent(name: eventName, parameters: parameters),
      ..._trackers.map(
        (tracker) => tracker.trackEvent(eventName, parameters: parameters),
      ),
    ]);
  }
}
