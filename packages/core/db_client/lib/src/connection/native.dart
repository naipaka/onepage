import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
