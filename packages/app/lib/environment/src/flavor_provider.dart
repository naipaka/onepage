import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'flavor.dart';

part 'flavor_provider.g.dart';

/// Provide current Flavor.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) {
  return Flavor.values.byName(const String.fromEnvironment('flavor'));
}
