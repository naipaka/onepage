import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_client/photo_client.dart';

void main() {
  Widget build({VoidCallback? onDeleted, VoidCallback? onInfoShown}) {
    return MaterialApp(
      home: Scaffold(
        body: PhotoFileThumbnail(
          file: File('missing.jpg'),
          width: 64,
          height: 64,
          onDeleted: onDeleted,
          onInfoShown: onInfoShown,
        ),
      ),
    );
  }

  testWidgets('shows a placeholder when the file cannot be read', (
    tester,
  ) async {
    await tester.pumpWidget(build());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();

    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
  });

  testWidgets('decodes up to twice the display size on the long edge', (
    tester,
  ) async {
    await tester.pumpWidget(build());

    final image = tester.widget<Image>(find.byType(Image).first);
    final resized = image.image as ResizeImage;

    expect(resized.width, 384);
    expect(resized.height, 384);
    expect(resized.policy, ResizeImagePolicy.fit);
  });

  testWidgets('shows a placeholder in the viewer when the file is missing', (
    tester,
  ) async {
    await tester.pumpWidget(build());

    await tester.tap(find.byType(PhotoFileThumbnail));
    await tester.pumpAndSettle();
    final viewerImage = find.byWidgetPredicate(
      (widget) => widget is Image && widget.image is FileImage,
    );
    final image = tester.widget<Image>(viewerImage);

    await tester.pumpWidget(
      MaterialApp(
        key: UniqueKey(),
        home: Builder(
          builder: (context) {
            return image.errorBuilder!(context, Exception(), null);
          },
        ),
      ),
    );

    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
  });

  testWidgets('opens the viewer with its actions', (tester) async {
    var deleted = false;
    var infoShown = false;
    await tester.pumpWidget(
      build(
        onDeleted: () => deleted = true,
        onInfoShown: () => infoShown = true,
      ),
    );

    await tester.tap(find.byType(PhotoFileThumbnail));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.tap(find.byIcon(Icons.delete));

    expect(infoShown, isTrue);
    expect(deleted, isTrue);
  });
}
