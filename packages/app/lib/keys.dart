import 'package:flutter/foundation.dart';

/// Short alias for [Keys], so call sites read as `K.homePage`.
typedef K = Keys;

/// Keys used for Patrol integration tests.
class Keys {
  /// Creates the key namespace; only static members are used.
  const new();

  /// Root of the home page.
  static const homePage = Key('homePage');

  /// The scrollable diary calendar on the home page.
  static const diaryCalendar = Key('diaryCalendar');
}
