import 'dart:io';

import 'package:backup/src/backup_controller.dart';
import 'package:clock/clock.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;

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
    late BackupController backupController;

    setUp(() {
      mockDbClient = MockDbClient();
      mockDbConnection = MockDbConnection();
      mockPackageInfo = MockPackageInfo();
      backupController = BackupController(
        dbClient: mockDbClient,
        packageInfo: mockPackageInfo,
        dbConnection: mockDbConnection,
      );

      setUpMockPathProvider();
      setUpMockFilePicker();
      setUpMockShare();
    });

    tearDown(() {
      tearDownMockPathProvider();
      tearDownMockFilePicker();
      tearDownMockShare();
    });

    group('createBackupFile', () {
      test('creates backup file with correct name format', () async {
        when(mockPackageInfo.appName).thenReturn('One Page');
        when(mockPackageInfo.version).thenReturn('1.0.0');

        final now = DateTime(2024, 1, 15, 12, 30, 45);
        await withClock(Clock.fixed(now), () async {
          const expectedFileName = 'one page-v1.0.0-20240115123045.backup';
          final expectedFilePath = p.join('/tmp', expectedFileName);

          when(
            mockDbClient.writeBackupToFile(filePath: expectedFilePath),
          ).thenAnswer((_) async {});

          await backupController.createBackupFile();

          verify(
            mockDbClient.writeBackupToFile(filePath: expectedFilePath),
          ).called(1);
        });
      });

      test('throws exception when backup file creation fails', () async {
        when(mockPackageInfo.appName).thenReturn('One Page');
        when(mockPackageInfo.version).thenReturn('1.0.0');

        final now = DateTime(2024, 1, 15, 12, 30, 45);
        await withClock(Clock.fixed(now), () async {
          const expectedFileName = 'one page-v1.0.0-20240115123045.backup';
          final expectedFilePath = p.join('/tmp', expectedFileName);

          when(
            mockDbClient.writeBackupToFile(filePath: expectedFilePath),
          ).thenThrow(Exception('Failed to create backup'));

          expect(
            () => backupController.createBackupFile(),
            throwsException,
          );
        });
      });
    });

    group('restoreBackupFile', () {
      test('returns null when no file is selected', () async {
        setMockFilePickerResult(null);

        final result = await backupController.restoreBackupFile();
        expect(result, isNull);
      });

      test(
        'returns file path when backup file is successfully restored',
        () async {
          const backupFilePath = '/path/to/backup.backup';
          final validBackupFile = File('/tmp/import.sqlite');

          setMockFilePickerResult(
            FilePickerResult([
              PlatformFile(
                path: backupFilePath,
                name: 'backup.backup',
                size: 100,
              ),
            ]),
          );

          when(
            mockDbConnection.createValidBackupFile(
              backupFilePath: backupFilePath,
            ),
          ).thenAnswer((_) async => validBackupFile);
          when(
            mockDbConnection.restoreBackup(validBackupFile: validBackupFile),
          ).thenAnswer((_) async {});

          final result = await backupController.restoreBackupFile();
          expect(result, validBackupFile.path);

          verify(
            mockDbConnection.createValidBackupFile(
              backupFilePath: backupFilePath,
            ),
          ).called(1);
          verify(
            mockDbConnection.restoreBackup(validBackupFile: validBackupFile),
          ).called(1);
        },
      );

      test('throws exception when backup restoration fails', () async {
        const backupFilePath = '/path/to/backup.backup';

        setMockFilePickerResult(
          FilePickerResult([
            PlatformFile(
              path: backupFilePath,
              name: 'backup.backup',
              size: 100,
            ),
          ]),
        );

        when(
          mockDbConnection.createValidBackupFile(
            backupFilePath: backupFilePath,
          ),
        ).thenThrow(Exception('Failed to restore backup'));

        expect(
          () => backupController.restoreBackupFile(),
          throwsException,
        );
      });
    });
  });
}
