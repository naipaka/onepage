import 'dart:io';

import 'package:db_client/src/connection/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;

import '../../utils/mock.mocks.dart';
import '../../utils/mock_path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DbConnection', () {
    late Directory tempDir;
    late Directory appSupportDir;
    late Directory appDocDir;

    late MockSqlite3 mockSqlite3;
    late MockDatabase mockDatabase;

    late DbConnection connection;

    setUp(() {
      // Create temporary directories for testing
      tempDir = Directory.systemTemp.createTempSync();
      appSupportDir = Directory('${tempDir.path}/app_support')..createSync();
      appDocDir = Directory('${tempDir.path}/app_doc')..createSync();

      // Set up mock path provider
      setUpMockPathProvider(
        tempDir: tempDir.path,
        appSupportDir: appSupportDir.path,
        appDocDir: appDocDir.path,
      );

      mockSqlite3 = MockSqlite3();
      mockDatabase = MockDatabase();
      connection = DbConnection()..sqlite3Instance = mockSqlite3;
    });

    tearDown(() {
      // Restore original state
      tearDownMockPathProvider();
      tempDir.deleteSync(recursive: true);
    });

    group('ensureDatabaseFileMigration', () {
      test('Moves DB file to the new location when an old DB file exists',
          () async {
        // Create old DB file
        final oldDbFile = File(p.join(appDocDir.path, 'onepage.db.sqlite'))
          ..createSync()
          ..writeAsStringSync('test data');

        // Execute migration
        await connection.ensureDatabaseFileMigration();

        // Verify the old file has been deleted
        expect(oldDbFile.existsSync(), isFalse);

        // Verify the new file has been created
        final newDbFile = File(p.join(appSupportDir.path, 'onepage.sqlite'));
        expect(newDbFile.existsSync(), isTrue);
        expect(newDbFile.readAsStringSync(), equals('test data'));
      });

      test('Does nothing when the old DB file does not exist', () async {
        // Execute migration
        await connection.ensureDatabaseFileMigration();

        // Verify the new file has not been created
        final newDbFile = File(p.join(appSupportDir.path, 'onepage.sqlite'));
        expect(newDbFile.existsSync(), isFalse);
      });
    });

    group('getDatabaseFile', () {
      test('Returns database file with the correct path', () async {
        final dbFile = await connection.getDatabaseFile();
        expect(
          dbFile.path,
          equals(p.join(appSupportDir.path, 'onepage.sqlite')),
        );
      });
    });

    group('createValidBackupFile', () {
      test('Creates a backup file', () async {
        // Specify backup file path
        final backupFilePath = p.join(tempDir.path, 'backup.sqlite');
        // Valid backup file path
        final validBackupFilePath = p.join(tempDir.path, 'import.sqlite');

        when(
          mockSqlite3.open(backupFilePath),
        ).thenReturn(mockDatabase);
        when(
          mockDatabase.execute('VACUUM INTO ?', [validBackupFilePath]),
        ).thenAnswer((_) {});
        when(
          mockDatabase.dispose(),
        ).thenAnswer((_) {});

        // Execute
        final result = await connection.createValidBackupFile(
          backupFilePath: backupFilePath,
        );

        // Verify
        expect(result.path, equals(validBackupFilePath));

        // Verify mocks
        verify(mockSqlite3.open(backupFilePath)).called(1);
        verify(mockDatabase.execute('VACUUM INTO ?', [validBackupFilePath]))
            .called(1);
        verify(mockDatabase.dispose()).called(1);
      });

      test('Throws an exception when the backup file is invalid', () async {
        // Specify backup file path
        final backupFilePath = p.join(tempDir.path, 'invalid_backup.sqlite');

        when(
          mockSqlite3.open(backupFilePath),
        ).thenThrow(Exception('Invalid database file'));

        // Execute and verify
        expect(
          () =>
              connection.createValidBackupFile(backupFilePath: backupFilePath),
          throwsException,
        );
      });
    });

    group('restoreBackup', () {
      test('Restores database from a backup file', () async {
        // Create original DB file
        final dbFile = File(p.join(appSupportDir.path, 'onepage.sqlite'))
          ..createSync()
          ..writeAsStringSync('original data');

        // Create valid backup file
        final validBackupFile = File(p.join(tempDir.path, 'import.sqlite'))
          ..createSync()
          ..writeAsStringSync('backup data');

        // Execute restoration
        await connection.restoreBackup(validBackupFile: validBackupFile);

        // Verify the original DB file has been overwritten
        expect(dbFile.readAsStringSync(), equals('backup data'));

        // Verify the backup file has been deleted
        expect(validBackupFile.existsSync(), isFalse);
      });
    });
  });
}
