import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'configurator_provider.dart';

part 'initialization_provider.g.dart';

/// Providers that need to initialize asynchronously only once at startup.
@Riverpod(keepAlive: true)
Future<void> initialization(Ref ref) async {
  ref.onDispose(() {
    // Clean up
    ref
      ..invalidate(packageInfoInitializingProvider)
      ..invalidate(configuratorInitializingProvider);
  });
  // Concurrent initialization
  await Future.wait([
    ref.watch(packageInfoInitializingProvider.future),
    ref.watch(configuratorInitializingProvider.future),
  ]);
}
