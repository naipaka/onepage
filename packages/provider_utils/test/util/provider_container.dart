import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/test.dart';

/// createContainer creates a ProviderContainer to be used in the test.
ProviderContainer createContainer({
  List<Override> overrides = const [],
  List<ProviderObserver> observers = const [],
}) {
  final container = ProviderContainer(
    overrides: overrides,
    observers: observers,
  );
  addTearDown(container.dispose);
  return container;
}
