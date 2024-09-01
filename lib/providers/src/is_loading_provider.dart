import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_loading_provider.g.dart';

/// A provider that manages the loading indicator.
@riverpod
class IsLoading extends _$IsLoading {
  @override
  bool build() => false;

  /// Show the loading indicator.
  void show() => state = true;

  /// Hide the loading indicator.
  void hide() => state = false;
}
