import 'package:db_client/src/db_client.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = DbClient(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v1 to v2 does not corrupt data', () async {
    final date = DateTime(2024);
    final oldDiariesData = <v1.DiariesData>[
      v1.DiariesData(
        id: 1,
        content: 'Test diary',
        date: date,
        createdAt: date,
        updatedAt: date,
      ),
    ];
    final expectedNewDiariesData = <v2.DiariesData>[
      v2.DiariesData(
        id: 1,
        content: 'Test diary',
        date: date,
        createdAt: date,
        updatedAt: date,
      ),
    ];

    const selectIndexQuery =
        'SELECT name FROM sqlite_master '
        "WHERE type='index' "
        "AND name='idx_diaries_date'";

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: DbClient.new,
      createItems: (batch, oldDb) async {
        batch.insertAll(oldDb.diaries, oldDiariesData);

        // Verify that the index does not exist in the old database
        final indexes = await oldDb.customSelect(selectIndexQuery).get();
        expect(indexes, isEmpty);
      },
      validateItems: (newDb) async {
        expect(expectedNewDiariesData, await newDb.select(newDb.diaries).get());

        // Verify that the index exists in the new database
        final indexes = await newDb.customSelect(selectIndexQuery).get();
        expect(indexes.length, 1);
        expect(indexes.first.data['name'], 'idx_diaries_date');
      },
    );
  });
}
