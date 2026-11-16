import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:backup/src/backup_controller.dart';
import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:photo_storage/photo_storage.dart';

import '../utils/db_client.dart';
import '../utils/mock_file_picker.dart';
import '../utils/mock_path_provider.dart';
import '../utils/mock_share_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BackupController', () {
    late DbClient dbClient;
    late Directory root;
    late Directory temporaryDirectory;
    late Directory supportDirectory;
    late PhotoStorage photoStorage;
    late BackupController backupController;
    late List<int> backupDatabase;

    String currentDatabasePath() =>
        p.join(supportDirectory.path, DbConnection.databaseFileName);

    File zipWith(Map<String, List<int>> entries) {
      final archive = Archive();
      entries.forEach((name, content) {
        archive.add(ArchiveFile.bytes(name, content));
      });
      return File(p.join(root.path, 'backup.backup'))
        ..writeAsBytesSync(ZipEncoder().encode(archive));
    }

    File validZip({int version = 1}) {
      return zipWith({
        'manifest.json': utf8.encode(jsonEncode({'version': version})),
        'onepage.sqlite': backupDatabase,
        'photos/new.jpg': [2],
      });
    }

    setUp(() async {
      dbClient = await openDbClient();
      addTearDown(dbClient.close);
      root = Directory.systemTemp.createTempSync('backup_controller_test');
      temporaryDirectory = Directory(p.join(root.path, 'tmp'))..createSync();
      supportDirectory = Directory(p.join(root.path, 'support'))..createSync();
      photoStorage = PhotoStorage(
        directory: Directory(p.join(root.path, 'photos')),
      );
      backupDatabase = (await writeDatabaseFile(
        p.join(root.path, 'backup.sqlite'),
        content: 'restored',
      )).readAsBytesSync();
      backupController = BackupController(
        dbClient: dbClient,
        packageInfo: PackageInfo(
          appName: 'One Page',
          packageName: 'jp.co.altive.onepage',
          version: '1.0.0',
          buildNumber: '1',
        ),
        dbConnection: DbConnection(),
        photoStorage: photoStorage,
      );

      setUpMockPathProvider(
        temporaryPath: temporaryDirectory.path,
        supportPath: supportDirectory.path,
      );
      setUpMockFilePicker();
      setUpMockShare();
    });

    tearDown(() {
      tearDownMockPathProvider();
      tearDownMockFilePicker();
      tearDownMockShare();
      root.deleteSync(recursive: true);
    });

    group('createBackupFile', () {
      const fileName = 'one page-v1.0.0-20240115123045.backup';
      final now = DateTime(2024, 1, 15, 12, 30, 45);

      Future<void> addImages(List<String> fileNames) async {
        final diary = await dbClient.insertDiary(
          content: 'Diary',
          date: DateTime(2024),
        );
        for (final fileName in fileNames) {
          await dbClient.insertDiaryImage(
            diaryId: diary.id,
            fileName: fileName,
          );
        }
      }

      Future<Archive> createBackup() async {
        await withClock(
          Clock.fixed(now),
          backupController.createBackupFile,
        );
        final file = File(p.join(temporaryDirectory.path, fileName));
        return ZipDecoder().decodeBytes(file.readAsBytesSync());
      }

      test('stores the manifest and the database', () async {
        await dbClient.insertDiary(content: 'Diary', date: DateTime(2024));

        final archive = await createBackup();

        final manifest = archive.findFile('manifest.json')!.readBytes()!;
        expect(jsonDecode(utf8.decode(manifest)), {'version': 1});
        final database = File(p.join(root.path, 'stored.sqlite'))
          ..writeAsBytesSync(archive.findFile('onepage.sqlite')!.readBytes()!);
        expect(await readDiaryContents(database.path), ['Diary']);
      });

      test('stores only the referenced photos', () async {
        final kept = await photoStorage.save(Uint8List.fromList([1]));
        await photoStorage.save(Uint8List.fromList([2]));
        await addImages([kept, 'missing.jpg']);

        final archive = await createBackup();

        expect(
          archive.files
              .where((file) => file.name.startsWith('photos/'))
              .map(
                (file) => file.name,
              ),
          ['photos/$kept'],
        );
      });

      test('reports progress for each stored photo', () async {
        final first = await photoStorage.save(Uint8List.fromList([1]));
        final second = await photoStorage.save(Uint8List.fromList([2]));
        await addImages([first, second, 'missing.jpg']);
        final progress = <(int, int)>[];

        await withClock(
          Clock.fixed(now),
          () => backupController.createBackupFile(
            onProgress: (completed, total) {
              progress.add((completed, total));
            },
          ),
        );
        expect(progress, [(1, 2), (2, 2)]);
      });

      test('throws when the database cannot be written', () async {
        await dbClient.close();

        await expectLater(
          backupController.createBackupFile(),
          throwsStateError,
        );
        expect(temporaryDirectory.listSync(), isEmpty);
      });
    });

    group('pickBackupFile', () {
      test('returns null when no file is selected', () async {
        setMockFilePickerResult(null);

        expect(await backupController.pickBackupFile(), isNull);
      });

      test('detects a zip backup', () async {
        final file = validZip();
        setMockFilePickerResult(FakePlatformFile(file.path));

        final backupFile = await backupController.pickBackupFile();

        expect(backupFile?.path, file.path);
        expect(backupFile?.isLegacy, isFalse);
      });

      test('treats any other file as a legacy backup', () async {
        final file = File(p.join(root.path, 'legacy.backup'))
          ..writeAsStringSync('SQLite format 3');
        setMockFilePickerResult(FakePlatformFile(file.path));

        final backupFile = await backupController.pickBackupFile();

        expect(backupFile?.isLegacy, isTrue);
      });

      test('treats a file shorter than the signature as legacy', () async {
        final file = File(p.join(root.path, 'short.backup'))
          ..writeAsBytesSync([0x50]);
        setMockFilePickerResult(FakePlatformFile(file.path));

        final backupFile = await backupController.pickBackupFile();

        expect(backupFile?.isLegacy, isTrue);
      });
    });

    group('restoreBackupFile', () {
      late String oldPhoto;

      setUp(() async {
        oldPhoto = await photoStorage.save(Uint8List.fromList([9]));
        await writeDatabaseFile(currentDatabasePath(), content: 'current');
      });

      Future<void> restore(File file, {bool isLegacy = false}) {
        return backupController.restoreBackupFile(
          BackupFile(path: file.path, isLegacy: isLegacy),
        );
      }

      Future<void> expectCurrentDataKept() async {
        expect(photoStorage.file(oldPhoto).existsSync(), isTrue);
        expect(await readDiaryContents(currentDatabasePath()), ['current']);
      }

      void expectDbClientClosed() {
        expect(
          () => dbClient.getDiaries(from: DateTime(2000), to: DateTime(2100)),
          throwsStateError,
        );
      }

      test('replaces the database and photos', () async {
        await restore(validZip());

        expect(photoStorage.file('new.jpg').readAsBytesSync(), [2]);
        expect(photoStorage.file(oldPhoto).existsSync(), isFalse);
        expect(await readDiaryContents(currentDatabasePath()), ['restored']);
      });

      test('reports progress for each extracted photo', () async {
        final file = zipWith({
          'manifest.json': utf8.encode(jsonEncode({'version': 1})),
          'onepage.sqlite': backupDatabase,
          'photos/first.jpg': [2],
          'photos/second.jpg': [3],
        });
        final progress = <(int, int)>[];

        await backupController.restoreBackupFile(
          BackupFile(path: file.path, isLegacy: false),
          onProgress: (completed, total) {
            progress.add((completed, total));
          },
        );

        expect(progress, [(1, 2), (2, 2)]);
      });

      test('closes the database client', () async {
        await restore(validZip());

        expectDbClientClosed();
      });

      test('closes the database when the backup is invalid', () async {
        await expectLater(
          restore(validZip(version: 2)),
          throwsFormatException,
        );

        expectDbClientClosed();
      });

      test('removes the photos when restoring a legacy backup', () async {
        final file = File(p.join(root.path, 'legacy.backup'))
          ..writeAsBytesSync(backupDatabase);

        await restore(file, isLegacy: true);

        expect(photoStorage.file(oldPhoto).existsSync(), isFalse);
        expect(await readDiaryContents(currentDatabasePath()), ['restored']);
      });

      test('keeps current data when the database is invalid', () async {
        backupDatabase = utf8.encode('not a database');

        await expectLater(restore(validZip()), throwsException);

        await expectCurrentDataKept();
      });

      test('puts the photos back when restoring the database fails', () async {
        File(currentDatabasePath()).deleteSync();
        Directory(currentDatabasePath()).createSync();

        await expectLater(restore(validZip()), throwsException);

        expect(photoStorage.file(oldPhoto).existsSync(), isTrue);
        expect(photoStorage.file('new.jpg').existsSync(), isFalse);
      });

      test('rejects a backup without a manifest', () async {
        final file = zipWith({'onepage.sqlite': backupDatabase});

        await expectLater(restore(file), throwsFormatException);

        await expectCurrentDataKept();
      });

      test('rejects an unsupported version', () async {
        await expectLater(
          restore(validZip(version: 2)),
          throwsFormatException,
        );

        await expectCurrentDataKept();
      });

      test('rejects a backup without a database', () async {
        final file = zipWith({
          'manifest.json': utf8.encode(jsonEncode({'version': 1})),
        });

        await expectLater(restore(file), throwsFormatException);

        await expectCurrentDataKept();
      });

      test('ignores entries outside the photos directory', () async {
        final file = zipWith({
          'manifest.json': utf8.encode(jsonEncode({'version': 1})),
          'onepage.sqlite': backupDatabase,
          '../outside.jpg': [2],
          'photos/nested/photo.jpg': [3],
        });

        await restore(file);

        expect(File(p.join(root.path, 'outside.jpg')).existsSync(), isFalse);
        expect(photoStorage.directory.listSync(), isEmpty);
      });
    });
  });
}
