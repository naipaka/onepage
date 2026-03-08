import 'dart:io';

import 'package:exporter/exporter.dart';
import 'package:flutter_test/flutter_test.dart';

class TestExporter extends Exporter {
  @override
  Future<File> export({required List<ExportDiary> entries}) async {
    // Mock implementation for testing
    final tempFile = File('/tmp/test_export.txt');
    await tempFile.writeAsString('Test export: ${entries.length} entries');
    return tempFile;
  }

  @override
  Future<File> exportMonth({
    required List<ExportDiary> entries,
    required int year,
    required int month,
  }) async {
    final tempFile = File('/tmp/test_export_month.txt');
    await tempFile.writeAsString(
      'Test export month: $year-$month, ${entries.length} entries',
    );
    return tempFile;
  }

  @override
  Future<File> exportDateRange({
    required List<ExportDiary> entries,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final tempFile = File('/tmp/test_export_range.txt');
    await tempFile.writeAsString(
      'Test export range: ${startDate.toIso8601String()} to '
      '${endDate.toIso8601String()}, ${entries.length} entries',
    );
    return tempFile;
  }
}

void main() {
  group('Exporter', () {
    test('can be extended', () {
      final exporter = TestExporter();
      expect(exporter, isA<Exporter>());
    });

    test('export method can be overridden', () async {
      final exporter = TestExporter();
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12),
          content: 'Test content',
        ),
      ];

      final file = await exporter.export(entries: entries);
      expect(file.existsSync(), isTrue);

      final content = await file.readAsString();
      expect(content, equals('Test export: 1 entries'));

      await file.delete();
    });

    test('concrete implementation can call base constructor', () {
      final exporter = TestExporter();
      expect(exporter, isA<Exporter>());
    });

    test('exportMonth method can be overridden', () async {
      final exporter = TestExporter();
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12),
          content: 'Test content',
        ),
      ];

      final file = await exporter.exportMonth(
        entries: entries,
        year: 2023,
        month: 12,
      );
      expect(file.existsSync(), isTrue);

      final content = await file.readAsString();
      expect(content, equals('Test export month: 2023-12, 1 entries'));

      await file.delete();
    });

    test('exportDateRange method can be overridden', () async {
      final exporter = TestExporter();
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12),
          content: 'Test content',
        ),
      ];

      final startDate = DateTime(2023, 12);
      final endDate = DateTime(2023, 12, 31);
      final file = await exporter.exportDateRange(
        entries: entries,
        startDate: startDate,
        endDate: endDate,
      );
      expect(file.existsSync(), isTrue);

      final content = await file.readAsString();
      expect(content, contains('Test export range:'));
      expect(content, contains('2023-12'));
      expect(content, contains('1 entries'));

      await file.delete();
    });
  });
}
