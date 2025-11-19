import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'flavor.dart';

part 'flavor_provider.g.dart';

/// Provide current Flavor.
///
/// Need override in top-level ProviderScope.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) {
  throw UnimplementedError();
}
