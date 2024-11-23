import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/providers.dart';

/// Provides extension methods for [WidgetRef].
extension WidgetRefExtension on WidgetRef {
  /// Shows the loading indicator.
  void showLoading() => read(isLoadingProvider.notifier).show();

  /// Hides the loading indicator.
  void hideLoading() => read(isLoadingProvider.notifier).hide();
}
