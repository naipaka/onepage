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

  group('create recovery', () {
    test('puts back photos left by an interrupted replacement', () async {
      PathProviderPlatform.instance = _FakePathProvider(root.path);
      final previous = Directory(p.join(root.path, 'photos.previous'))
        ..createSync();
      File(p.join(previous.path, 'photo.jpg')).writeAsBytesSync(bytes);

      final created = await PhotoStorage.create();

      expect(created.file('photo.jpg').existsSync(), isTrue);
      expect(previous.existsSync(), isFalse);
    });
  });

  group('replacement', () {
    late String oldPhoto;

    setUp(() async {
      oldPhoto = await storage.save(bytes);
      await storage.resetStaging();
      File(
        p.join(storage.stagingDirectory.path, 'new.jpg'),
      ).writeAsBytesSync(bytes);
    });

    test('resetStaging removes stale files', () async {
      await storage.resetStaging();

      expect(storage.stagingDirectory.listSync(), isEmpty);
    });

    test('commit keeps only the staged photos', () async {
      await storage.replaceWithStaged();
      await storage.commitReplacement();

      expect(storage.file('new.jpg').existsSync(), isTrue);
      expect(storage.file(oldPhoto).existsSync(), isFalse);
      expect(storage.stagingDirectory.existsSync(), isFalse);
    });

    test('rollback restores the previous photos', () async {
      await storage.replaceWithStaged();
      await storage.rollbackReplacement();

      expect(storage.file(oldPhoto).existsSync(), isTrue);
      expect(storage.file('new.jpg').existsSync(), isFalse);
    });

    test('works when there are no current photos', () async {
      await storage.directory.delete(recursive: true);

      await storage.replaceWithStaged();
      expect(storage.file('new.jpg').existsSync(), isTrue);

      await storage.rollbackReplacement();
      expect(storage.directory.existsSync(), isFalse);
    });

    test('replaces leftovers from an earlier replacement', () async {
      await storage.replaceWithStaged();
      await storage.resetStaging();

      await storage.replaceWithStaged();

      expect(storage.directory.listSync(), isEmpty);
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
