import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  new(this.path);

  final String path;

  @override
  Future<String?> getApplicationSupportPath() async => path;
}

void main() {
  late Directory root;
  late PhotoStorage storage;
  final bytes = Uint8List.fromList([1, 2, 3]);

  setUp(() async {
    root = await Directory.systemTemp.createTemp('photo_storage_test');
    storage = PhotoStorage(directory: Directory(p.join(root.path, 'photos')));
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  group('create', () {
    test('uses the photos directory in application support', () async {
      PathProviderPlatform.instance = _FakePathProvider(root.path);

      final created = await PhotoStorage.create();

      expect(created.directory.path, p.join(root.path, 'photos'));
    });
  });

  group('save', () {
    test('writes the bytes and returns a file name', () async {
      final fileName = await storage.save(bytes);

      expect(fileName, endsWith('.jpg'));
      expect(storage.file(fileName).readAsBytesSync(), bytes);
    });

    test('returns a different name for each photo', () async {
      final first = await storage.save(bytes);
      final second = await storage.save(bytes);

      expect(first, isNot(second));
    });

    test('leaves no temporary file', () async {
      await storage.save(bytes);

      final names = storage.directory.listSync().map((e) => e.path);
      expect(names.where((name) => name.endsWith('.tmp')), isEmpty);
    });
  });

  group('delete', () {
    test('removes the photo', () async {
      final fileName = await storage.save(bytes);

      await storage.delete(fileName);

      expect(storage.file(fileName).existsSync(), isFalse);
    });

    test('does nothing when the photo does not exist', () async {
      await expectLater(storage.delete('missing.jpg'), completes);
    });
  });
}
