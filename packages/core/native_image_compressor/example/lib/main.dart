import 'package:flutter/material.dart';
import 'package:native_image_compressor/native_image_compressor.dart';

void main() {
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
