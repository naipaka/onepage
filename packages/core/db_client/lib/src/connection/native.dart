import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// {@template db_client.Connection}
/// A class that defines methods with side effects related to database
/// connection.
/// {@endtemplate}
class DbConnection {
  /// {@macro db_client.Connection}
  DbConnection();

  /// The SQLite3 instance used for database operations.
  ///
  /// This is marked as `@visibleForTesting` to allow for testing with a mock
  /// SQLite3 instance.
  @visibleForTesting
  Sqlite3 sqlite3Instance = sqlite3;

  /// Ensures that the database file is migrated correctly.
  ///
  /// In version v1.0.0, the database name mistakenly included the `.db`
  /// extension, despite the requirement that only alphabetic characters
  /// and underscores are allowed in the name. This method was introduced
  /// in versions after v1.0.0 to rename the database file to meet the
  /// correct naming conventions.
  ///
  /// Additionally, as the recommended storage directory for the database
  /// has changed, this method also moves the database file to the new
  /// recommended directory.
  ///
  /// Reference:
  /// https://github.com/simolus3/drift/commit/7191459350f8d6aa5056ee60f98d3bf280015123
  Future<void> ensureDatabaseFileMigration() async {
    final oldDbDir = await getApplicationDocumentsDirectory();
    final oldDbPath = p.join(oldDbDir.path, 'onepage.db.sqlite');
    final oldDbFile = File(oldDbPath);
    if (oldDbFile.existsSync()) {
      final newDbDir = await getApplicationSupportDirectory();
      final newDbPath = p.join(newDbDir.path, 'onepage.sqlite');
      await oldDbFile.rename(newDbPath);
    }
  }

  /// Returns the database file.
  Future<File> getDatabaseFile() async {
    final appDir = await getApplicationSupportDirectory();
    final dbPath = p.join(appDir.path, 'onepage.sqlite');
    return File(dbPath);
  }

  /// Creates a valid database file from the provided backup file.
  ///
  /// This method takes [backupFilePath] as input, verifies that the file is a
  /// valid database backup, and creates a new temporary database file for use.
  ///
  /// Returns the path to the newly created temporary database file.
  /// Throws an exception if the input file is not a valid database.
  Future<File> createValidBackupFile({required String backupFilePath}) async {
    final newDbFileDir = await getTemporaryDirectory();
    final newDbFilePath = p.join(newDbFileDir.path, 'import.sqlite');
    sqlite3Instance.open(backupFilePath)
      ..execute('VACUUM INTO ?', [newDbFilePath])
      ..dispose();
    return File(newDbFilePath);
  }

  /// Restores the database from the provided backup file.
  ///
  /// This method takes [validBackupFile] as input and replaces the current
  /// database file with the backup file.
  Future<void> restoreBackup({required File validBackupFile}) async {
    final currentDbFile = await getDatabaseFile();
    await validBackupFile.copy(currentDbFile.path);
    await validBackupFile.delete();
  }
}
