import 'package:flutter/foundation.dart';
import 'package:simple_logger/simple_logger.dart';

export 'provider_logger.dart';

/// ロガー。
final logger = SimpleLogger()
  ..setLevel(
    Level.FINEST,
    includeCallerInfo: kDebugMode,
  );
