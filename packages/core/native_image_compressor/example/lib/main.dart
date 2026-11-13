import 'package:material_ui/material_ui.dart';
import 'package:native_image_compressor/native_image_compressor.dart';

void main() {
  // The example app does not use Riverpod. The workspace root enables
  // riverpod_lint for every package.
  // ignore: riverpod_lint/missing_provider_scope
  runApp(const _ExampleApp());
}

class _ExampleApp extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: const NativeImageCompressor().compress('missing.jpg'),
            builder: (_, snapshot) => Text('${snapshot.error}'),
          ),
        ),
      ),
    );
  }
}
