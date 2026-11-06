import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:backup/src/backup_controller.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import 'package:photo_storage/photo_storage.dart';

import '../utils/mock.mocks.dart';
import '../utils/mock_file_picker.dart';
import '../utils/mock_path_provider.dart';
import '../utils/mock_share_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BackupController', () {
    late MockDbClient mockDbClient;
    late MockDbConnection mockDbConnection;
    late MockPackageInfo mockPackageInfo;
    late Directory root;
    late PhotoStorage photoStorage;
    late BackupController backupController;

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
        'onepage.sqlite': [1],
        'photos/new.jpg': [2],
      });
    }

    setUp(() {
      mockDbClient = MockDbClient();
      mockDbConnection = MockDbConnection();
      mockPackageInfo = MockPackageInfo();
      root = Directory.systemTemp.createTempSync('backup_controller_test');
      photoStorage = PhotoStorage(
        directory: Directory(p.join(root.path, 'photos')),
      );
      backupController = BackupController(
        dbClient: mockDbClient,
        packageInfo: mockPackageInfo,
        dbConnection: mockDbConnection,
        photoStorage: photoStorage,
      );

      when(mockPackageInfo.appName).thenReturn('One Page');
      when(mockPackageInfo.version).thenReturn('1.0.0');
      when(
        mockDbClient.writeBackupToFile(filePath: anyNamed('filePath')),
      ).thenAnswer((invocation) async {
        final path = invocation.namedArguments[#filePath] as String;
        File(path).writeAsBytesSync([1, 2, 3]);
      });
      when(
        mockDbClient.getDiaryImageFileNames(),
      ).thenAnswer((_) async => {});
      when(
        mockDbConnection.createValidBackupFile(
          backupFilePath: anyNamed('backupFilePath'),
        ),
      ).thenAnswer((_) async => File('valid.sqlite'));

      setUpMockPathProvider();
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

      Future<Archive> createBackup() async {
        await withClock(
          Clock.fixed(now),
          backupController.createBackupFile,
        );
        final file = File(p.join('/tmp', fileName));
        addTearDown(file.deleteSync);
        return ZipDecoder().decodeBytes(file.readAsBytesSync());
      }

      test('stores the manifest and the database', () async {
        final archive = await createBackup();

        final manifest = archive.findFile('manifest.json')!.readBytes()!;
        expect(jsonDecode(utf8.decode(manifest)), {'version': 1});
        expect(archive.findFile('onepage.sqlite')!.readBytes(), [1, 2, 3]);
      });

      test('stores only the referenced photos', () async {
        final kept = await photoStorage.save(Uint8List.fromList([1]));
        await photoStorage.save(Uint8List.fromList([2]));
        when(
          mockDbClient.getDiaryImageFileNames(),
        ).thenAnswer((_) async => {kept, 'missing.jpg'});

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
        when(
          mockDbClient.getDiaryImageFileNames(),
        ).thenAnswer((_) async => {first, second, 'missing.jpg'});
        final progress = <(int, int)>[];

        await withClock(
          Clock.fixed(now),
          () => backupController.createBackupFile(
            onProgress: (completed, total) {
              progress.add((completed, total));
            },
          ),
        );
        addTearDown(File(p.join('/tmp', fileName)).deleteSync);

        expect(progress, [(1, 2), (2, 2)]);
      });

      test('throws when the database cannot be written', () async {
        when(
          mockDbClient.writeBackupToFile(filePath: anyNamed('filePath')),
        ).thenThrow(Exception('Failed to create backup'));

        await expectLater(
          backupController.createBackupFile(),
          throwsException,
        );
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
      });

      Future<void> restore(File file, {bool isLegacy = false}) {
        return backupController.restoreBackupFile(
          BackupFile(path: file.path, isLegacy: isLegacy),
        );
      }

      void expectCurrentDataKept() {
        expect(photoStorage.file(oldPhoto).existsSync(), isTrue);
        verifyNever(
          mockDbConnection.restoreBackup(
            validBackupFile: anyNamed('validBackupFile'),
          ),
        );
      }

      test('replaces the database and photos', () async {
        await restore(validZip());

        expect(photoStorage.file('new.jpg').readAsBytesSync(), [2]);
        expect(photoStorage.file(oldPhoto).existsSync(), isFalse);
        verify(
          mockDbConnection.restoreBackup(
            validBackupFile: anyNamed('validBackupFile'),
          ),
        ).called(1);
      });

      test('reports progress for each extracted photo', () async {
        final file = zipWith({
          'manifest.json': utf8.encode(jsonEncode({'version': 1})),
          'onepage.sqlite': [1],
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

      test('closes the database once before anything else', () async {
        await restore(validZip());

        verifyInOrder([
          mockDbClient.close(),
          mockDbConnection.createValidBackupFile(
            backupFilePath: anyNamed('backupFilePath'),
          ),
          mockDbConnection.restoreBackup(
            validBackupFile: anyNamed('validBackupFile'),
          ),
        ]);
        verifyNoMoreInteractions(mockDbClient);
      });

      test('closes the database when the backup is invalid', () async {
        await expectLater(
          restore(validZip(version: 2)),
          throwsFormatException,
        );

        verify(mockDbClient.close()).called(1);
      });

      test('removes the photos when restoring a legacy backup', () async {
        final file = File(p.join(root.path, 'legacy.backup'))
          ..writeAsBytesSync([1]);

        await restore(file, isLegacy: true);

        expect(photoStorage.file(oldPhoto).existsSync(), isFalse);
        verify(
          mockDbConnection.createValidBackupFile(backupFilePath: file.path),
        ).called(1);
      });

      test('keeps current data when the database is invalid', () async {
        when(
          mockDbConnection.createValidBackupFile(
            backupFilePath: anyNamed('backupFilePath'),
          ),
        ).thenThrow(Exception('Invalid database'));

        await expectLater(restore(validZip()), throwsException);

        expectCurrentDataKept();
      });

      test('puts the photos back when restoring the database fails', () async {
        when(
          mockDbConnection.restoreBackup(
            validBackupFile: anyNamed('validBackupFile'),
          ),
        ).thenThrow(Exception('Failed to restore'));

        await expectLater(restore(validZip()), throwsException);

        expect(photoStorage.file(oldPhoto).existsSync(), isTrue);
        expect(photoStorage.file('new.jpg').existsSync(), isFalse);
      });

      test('rejects a backup without a manifest', () async {
        final file = zipWith({
          'onepage.sqlite': [1],
        });

        await expectLater(restore(file), throwsFormatException);

        expectCurrentDataKept();
      });

      test('rejects an unsupported version', () async {
        await expectLater(
          restore(validZip(version: 2)),
          throwsFormatException,
        );

        expectCurrentDataKept();
      });

      test('rejects a backup without a database', () async {
        final file = zipWith({
          'manifest.json': utf8.encode(jsonEncode({'version': 1})),
        });

        await expectLater(restore(file), throwsFormatException);

        expectCurrentDataKept();
      });

      test('ignores entries outside the photos directory', () async {
        final file = zipWith({
          'manifest.json': utf8.encode(jsonEncode({'version': 1})),
          'onepage.sqlite': [1],
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
