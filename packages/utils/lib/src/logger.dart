import 'package:flutter/foundation.dart';
import 'package:simple_logger/simple_logger.dart';

/// Logger instance for the package.
final logger = SimpleLogger()
  ..setLevel(
    Level.FINEST,
    includeCallerInfo: kDebugMode,
  );
