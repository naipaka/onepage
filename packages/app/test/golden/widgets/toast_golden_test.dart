@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgets/widgets.dart';

import '../golden_test_helpers.dart';

void main() {
  group('Toast Golden Tests', () {
    for (final variant in GoldenVariant.values) {
      testWidgets('renders a success toast with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          _ToastScreen(
            show: (context) => showSuccessToast(
              context,
              title: context.t.backup.successMessage,
              icon: const Icon(Icons.backup_outlined),
            ),
          ),
          'toast_success',
          variant: variant,
        );
      });

      testWidgets('renders an error toast with ${variant.suffix}', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          _ToastScreen(
            show: (context) => showErrorToast(
              context,
              title: context.t.backup.failedMessage,
            ),
          ),
          'toast_error',
          variant: variant,
        );
      });
    }
  });
}

/// {@template _ToastScreen}
/// An empty screen that shows a toast after its first frame.
/// {@endtemplate}
class _ToastScreen extends StatefulWidget {
  /// {@macro _ToastScreen}
  const new({required this.show});

  /// Called with the context of this screen after its first frame.
  final void Function(BuildContext context) show;

  @override
  State<_ToastScreen> createState() => _ToastScreenState();
}

class _ToastScreenState extends State<_ToastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.show(context));
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
