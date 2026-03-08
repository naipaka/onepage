import 'package:clock/clock.dart';
import 'package:exporter/exporter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CsvExporter', () {
    late CsvExporter exporter;
    late PackageInfo packageInfo;
    const tempDirPath = '/tmp';

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
              if (methodCall.method == 'getTemporaryDirectory') {
                return tempDirPath;
              }
              return null;
            },
          );
      packageInfo = PackageInfo(
        appName: 'OnePage',
        packageName: 'com.example.onepage',
        version: '1.0.0',
        buildNumber: '1',
      );
      exporter = CsvExporter(packageInfo: packageInfo);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
    });

    test('is an instance of Exporter', () {
      expect(exporter, isA<Exporter>());
    });

    test('constructor requires packageInfo', () {
      expect(
        () => CsvExporter(packageInfo: packageInfo),
        returnsNormally,
      );
    });

    group('export method', () {
      test('exports empty entries', () async {
        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.export(entries: []);

          expect(file.path, contains('.csv'));
          expect(file.path, contains('OnePage'));
          expect(file.path, contains('March 2024'));
          expect(file.path, contains('v1.0.0'));
          expect(file.path, contains('20240315123000'));

          final content = await file.readAsString();
          expect(content, equals('Date,Content\n'));
        });
      });

      test('exports single entry', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Test entry',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('Date,Content'));
        expect(content, contains('2024-01-15,Test entry'));
      });

      test('exports multiple entries sorted by date', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 20),
            content: 'Second entry',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 10),
            content: 'First entry',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 30),
            content: 'Third entry',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();
        final lines = content.trim().split('\n');

        expect(lines[0], 'Date,Content');
        expect(lines[1], '2024-01-10,First entry');
        expect(lines[2], '2024-01-20,Second entry');
        expect(lines[3], '2024-01-30,Third entry');
      });

      test('escapes CSV fields with commas', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Entry with, comma',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('2024-01-15,"Entry with, comma"'));
      });

      test('escapes CSV fields with quotes', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Entry with "quotes"',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('2024-01-15,"Entry with ""quotes"""'));
      });

      test('escapes CSV fields with newlines', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Entry with\nnewline',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('2024-01-15,"Entry with\nnewline"'));
      });

      test('escapes CSV fields with carriage returns', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Entry with\rcarriage return',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('2024-01-15,"Entry with\rcarriage return"'));
      });

      test('generates correct filename for single month', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Test',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 20),
            content: 'Test 2',
          ),
        ];

        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.export(entries: entries);
          final fileName = p.basename(file.path);

          expect(fileName, contains('January 2024'));
          expect(fileName, contains('OnePage'));
          expect(fileName, contains('v1.0.0'));
          expect(fileName, contains('20240315123000'));
          expect(fileName, endsWith('.csv'));
        });
      });

      test('generates correct filename for date range', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Test',
          ),
          ExportDiary(
            date: DateTime(2024, 3, 20),
            content: 'Test 2',
          ),
        ];

        final now = DateTime(2024, 3, 25, 14, 45);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.export(entries: entries);
          final fileName = p.basename(file.path);

          expect(fileName, contains('January 2024 - March 2024'));
          expect(fileName, contains('OnePage'));
          expect(fileName, contains('v1.0.0'));
          expect(fileName, contains('20240325144500'));
          expect(fileName, endsWith('.csv'));
        });
      });
    });

    group('exportMonth method', () {
      test('exports entries for specific month with all days', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 10),
            content: 'January entry',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 20),
            content: 'Another January entry',
          ),
          ExportDiary(
            date: DateTime(2024, 2, 15),
            content: 'February entry',
          ),
        ];

        final file = await exporter.exportMonth(
          entries: entries,
          year: 2024,
          month: 1,
        );
        final content = await file.readAsString();
        final lines = content.trim().split('\n');

        expect(lines.length, 32); // Header + 31 days
        expect(lines[0], 'Date,Content');
        expect(lines[10], '2024-01-10,January entry');
        expect(lines[20], '2024-01-20,Another January entry');
        expect(lines[1], '2024-01-01,'); // Empty day
        expect(lines[31], '2024-01-31,'); // Empty last day
      });

      test('handles February in leap year', () async {
        final file = await exporter.exportMonth(
          entries: [],
          year: 2024,
          month: 2,
        );
        final content = await file.readAsString();
        final lines = content.trim().split('\n');

        expect(lines.length, 30); // Header + 29 days (leap year)
        expect(lines[29], contains('2024-02-29'));
      });

      test('handles February in non-leap year', () async {
        final file = await exporter.exportMonth(
          entries: [],
          year: 2023,
          month: 2,
        );
        final content = await file.readAsString();
        final lines = content.trim().split('\n');

        expect(lines.length, 29); // Header + 28 days
        expect(lines[28], contains('2023-02-28'));
      });

      test('generates correct filename for month', () async {
        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.exportMonth(
            entries: [],
            year: 2024,
            month: 1,
          );
          final fileName = p.basename(file.path);

          expect(fileName, contains('January 2024'));
          expect(fileName, contains('OnePage'));
          expect(fileName, contains('v1.0.0'));
          expect(fileName, contains('20240315123000'));
          expect(fileName, endsWith('.csv'));
        });
      });

      test('filters entries by month', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'January entry',
          ),
          ExportDiary(
            date: DateTime(2024, 2, 15),
            content: 'February entry',
          ),
          ExportDiary(
            date: DateTime(2023, 1, 15),
            content: 'Previous year January',
          ),
        ];

        final file = await exporter.exportMonth(
          entries: entries,
          year: 2024,
          month: 1,
        );
        final content = await file.readAsString();

        expect(content, contains('2024-01-15,January entry'));
        expect(content, isNot(contains('February entry')));
        expect(content, isNot(contains('Previous year January')));
      });
    });

    group('exportDateRange method', () {
      test('exports entries within date range', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 10),
            content: 'Before range',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Start of range',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 20),
            content: 'Middle of range',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 25),
            content: 'End of range',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 30),
            content: 'After range',
          ),
        ];

        final file = await exporter.exportDateRange(
          entries: entries,
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 1, 25),
        );
        final content = await file.readAsString();

        expect(content, contains('2024-01-15,Start of range'));
        expect(content, contains('2024-01-20,Middle of range'));
        expect(content, contains('2024-01-25,End of range'));
        expect(content, isNot(contains('Before range')));
        expect(content, isNot(contains('After range')));
      });

      test('generates correct filename for single day', () async {
        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.exportDateRange(
            entries: [],
            startDate: DateTime(2024, 1, 15),
            endDate: DateTime(2024, 1, 15),
          );
          final fileName = p.basename(file.path);

          expect(fileName, contains('Mon Jan 15 2024'));
        });
      });

      test('generates correct filename for same month range', () async {
        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.exportDateRange(
            entries: [],
            startDate: DateTime(2024, 1, 10),
            endDate: DateTime(2024, 1, 20),
          );
          final fileName = p.basename(file.path);

          expect(fileName, contains('January 2024'));
        });
      });

      test('generates correct filename for cross-month range', () async {
        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.exportDateRange(
            entries: [],
            startDate: DateTime(2024, 1, 15),
            endDate: DateTime(2024, 3, 20),
          );
          final fileName = p.basename(file.path);

          expect(fileName, contains('Jan 15 2024 - Mar 20 2024'));
        });
      });

      test('handles edge case with time boundaries', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Midnight start',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 15, 23, 59, 59),
            content: 'Almost midnight',
          ),
        ];

        final file = await exporter.exportDateRange(
          entries: entries,
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 1, 15),
        );
        final content = await file.readAsString();

        expect(content, contains('Midnight start'));
        expect(content, contains('Almost midnight'));
      });
    });

    group('file handling', () {
      test('saves to temporary directory', () async {
        final file = await exporter.export(entries: []);

        expect(file.path, startsWith(tempDirPath));
      });

      test('creates valid file paths', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Test',
          ),
        ];

        final file = await exporter.export(entries: entries);

        expect(file.existsSync(), true);
      });

      test('sanitizes filename', () async {
        final now = DateTime(2024, 3, 15, 12, 30);

        packageInfo = PackageInfo(
          appName: 'One/Page:App',
          packageName: 'com.example.onepage',
          version: '1.0.0',
          buildNumber: '1',
        );
        exporter = CsvExporter(packageInfo: packageInfo);

        await withClock(Clock.fixed(now), () async {
          final file = await exporter.export(entries: []);
          final fileName = p.basename(file.path);

          expect(fileName, isNot(contains('/')));
          expect(fileName, isNot(contains(':')));
          expect(fileName, contains('OnePageApp'));
        });
      });
    });

    group('CSV format', () {
      test('uses proper line endings', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Test',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final bytes = await file.readAsBytes();
        final content = String.fromCharCodes(bytes);

        expect(content, contains('\n'));
        expect(content, endsWith('\n'));
      });

      test('handles empty content', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: '',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('2024-01-15,'));
      });

      test('handles special characters in content', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Test with 日本語 and émojis 🎉',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('Test with 日本語 and émojis 🎉'));
      });
    });
  });
}
