import 'package:device_photos/device_photos.dart';
import 'package:flutter/material.dart';

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
            future: const DevicePhotos().supportsFolder,
            builder: (_, snapshot) {
              return Text('Supports folders: ${snapshot.data}');
            },
          ),
        ),
      ),
    );
  }
}
