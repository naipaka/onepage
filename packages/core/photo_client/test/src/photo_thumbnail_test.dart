import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_client/photo_client.dart';

final _png = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x60, 0x00, 0x02, 0x00, //
  0x00, 0x05, 0x00, 0x01, 0xE9, 0xFA, 0xDC, 0xD8, 0x00, 0x00, 0x00, 0x00, //
  0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82, //
]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.fluttercandies/photo_manager');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late Directory directory;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('photo_thumbnail_test');
    final file = File('${directory.path}/photo.png')..writeAsBytesSync(_png);
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'getFullFile') {
        return file.path;
      }
      if (call.method == 'fetchEntityProperties') {
        return <String, dynamic>{
          'id': 'photo-id',
          'type': 1,
          'width': 100,
          'height': 100,
          'duration': 0,
          'favorite': false,
          'title': 'photo.jpg',
          'modifiedDt': 0,
          'createDt': 0,
        };
      }
      return _png;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    directory.deleteSync(recursive: true);
  });

  testWidgets('opens the viewer for a device photo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PhotoThumbnail(photoId: 'photo-id', width: 64, height: 64),
        ),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();

    await tester.tap(find.byType(PhotoThumbnail));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(InteractiveViewer), findsOneWidget);
  });
}
