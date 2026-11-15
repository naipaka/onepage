@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgets/widgets.dart';

import '../golden_test_helpers.dart';

void main() {
  group('Toast Golden Tests', () {
    for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('renders a success toast with ${themeMode.name} theme', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          _ToastScreen(
            show: (context) => showSuccessToast(
              context,
              title: 'Backup created successfully!',
              icon: const Icon(Icons.backup_outlined),
            ),
          ),
          'goldens/toast_success_${themeMode.name}_en.png',
          themeMode: themeMode,
        );
      });

      testWidgets('renders an error toast with ${themeMode.name} theme', (
        tester,
      ) async {
        await GoldenTestHelpers.expectGoldenMatches(
          tester,
          _ToastScreen(
            show: (context) => showErrorToast(
              context,
              title: 'Failed to create backup',
            ),
          ),
          'goldens/toast_error_${themeMode.name}_en.png',
          themeMode: themeMode,
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
