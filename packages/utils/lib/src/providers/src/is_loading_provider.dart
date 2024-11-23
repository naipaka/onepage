import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Provides extension methods for [WidgetRef].
extension WidgetRefExtensionForLoading on WidgetRef {
  /// Shows the loading indicator.
  void showLoading() => read(isLoadingProvider.notifier).show();

  /// Hides the loading indicator.
  void hideLoading() => read(isLoadingProvider.notifier).hide();
}
