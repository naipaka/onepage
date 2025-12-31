import 'package:clock/clock.dart';
import 'package:exporter/exporter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MarkdownExporter', () {
    late MarkdownExporter exporter;
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
      exporter = MarkdownExporter(packageInfo: packageInfo);
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
        () => MarkdownExporter(packageInfo: packageInfo),
        returnsNormally,
      );
    });

    group('export method', () {
      test('exports empty entries', () async {
        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.export(entries: []);

          expect(file.path, contains('.md'));
          expect(file.path, contains('OnePage'));
          expect(file.path, contains('March 2024'));
          expect(file.path, contains('v1.0.0'));
          expect(file.path, contains('20240315123000'));

          final content = await file.readAsString();
          expect(content, contains('# March 2024'));
          expect(content, contains('Exported from OnePage v1.0.0'));
          expect(content, contains('Mar 15, 2024'));
          expect(content, contains('---'));
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

        expect(content, contains('# January 2024'));
        expect(content, contains('## Mon, Jan 15, 2024'));
        expect(content, contains('Test entry'));
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
        final lines = content.split('\n');

        expect(content, contains('# January 2024'));

        final firstIndex = lines.indexOf('## Wed, Jan 10, 2024');
        final secondIndex = lines.indexOf('## Sat, Jan 20, 2024');
        final thirdIndex = lines.indexOf('## Tue, Jan 30, 2024');

        expect(firstIndex, lessThan(secondIndex));
        expect(secondIndex, lessThan(thirdIndex));
      });

      test('exports entries from different months', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'January entry',
          ),
          ExportDiary(
            date: DateTime(2024, 2, 10),
            content: 'February entry',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('# January 2024 - February 2024'));
        expect(content, contains('## Mon, Jan 15, 2024'));
        expect(content, contains('January entry'));
        expect(content, contains('## Sat, Feb 10, 2024'));
        expect(content, contains('February entry'));
      });

      test('handles multiline content', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Line 1\nLine 2\nLine 3',
          ),
        ];

        final file = await exporter.export(entries: entries);
        final content = await file.readAsString();

        expect(content, contains('Line 1\nLine 2\nLine 3'));
      });

      test('generates correct filename', () async {
        final now = DateTime(2024, 3, 15, 14, 45, 30);
        await withClock(Clock.fixed(now), () async {
          final entries = [
            ExportDiary(
              date: DateTime(2024, 1, 15),
              content: 'Test',
            ),
          ];

          final file = await exporter.export(entries: entries);
          const expectedFileName =
              'OnePage_January 2024_v1.0.0-20240315144530.md';

          expect(p.basename(file.path), equals(expectedFileName));
        });
      });

      test('sanitizes app name in filename', () async {
        final specialPackageInfo = PackageInfo(
          appName: 'One@Page!',
          packageName: 'com.example.onepage',
          version: '1.0.0',
          buildNumber: '1',
        );
        final specialExporter = MarkdownExporter(
          packageInfo: specialPackageInfo,
        );

        final file = await specialExporter.export(entries: []);

        expect(file.path, contains('OnePage_'));
        expect(file.path, isNot(contains('@')));
        expect(file.path, isNot(contains('!')));
      });
    });

    group('exportMonth method', () {
      test('exports empty month', () async {
        final now = DateTime(2024, 3, 15, 12, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.exportMonth(
            entries: [],
            year: 2024,
            month: 1,
          );

          expect(file.path, contains('.md'));
          expect(file.path, contains('January 2024'));

          final content = await file.readAsString();
          expect(content, contains('# January 2024'));
          expect(content, contains('Exported from OnePage v1.0.0'));
        });
      });

      test('exports month with entries', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'Mid-month entry',
          ),
          ExportDiary(
            date: DateTime(2024),
            content: 'New Year entry',
          ),
        ];

        final file = await exporter.exportMonth(
          entries: entries,
          year: 2024,
          month: 1,
        );

        final content = await file.readAsString();

        expect(content, contains('## Mon, Jan 1, 2024'));
        expect(content, contains('New Year entry'));
        expect(content, contains('## Mon, Jan 15, 2024'));
        expect(content, contains('Mid-month entry'));
      });

      test('includes all days of the month', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 2, 15),
            content: 'February entry',
          ),
        ];

        final file = await exporter.exportMonth(
          entries: entries,
          year: 2024,
          month: 2,
        );

        final content = await file.readAsString();

        expect(content, contains('## Thu, Feb 1, 2024'));
        expect(content, contains('## Thu, Feb 15, 2024'));
        expect(content, contains('February entry'));
        expect(content, contains('## Thu, Feb 29, 2024'));

        final noEntryCount = 'No entry'.allMatches(content).length;
        expect(noEntryCount, equals(28));
      });

      test('filters entries from other months', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: 'January entry',
          ),
          ExportDiary(
            date: DateTime(2024, 2, 10),
            content: 'February entry',
          ),
        ];

        final file = await exporter.exportMonth(
          entries: entries,
          year: 2024,
          month: 1,
        );

        final content = await file.readAsString();

        expect(content, contains('January entry'));
        expect(content, isNot(contains('February entry')));
      });

      test('handles empty content entries', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 15),
            content: '',
          ),
        ];

        final file = await exporter.exportMonth(
          entries: entries,
          year: 2024,
          month: 1,
        );

        final content = await file.readAsString();

        expect(content, contains('## Mon, Jan 15, 2024'));
        expect(content, contains('No entry'));
      });

      test('generates correct filename for month export', () async {
        final now = DateTime(2024, 3, 15, 14, 45, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.exportMonth(
            entries: [],
            year: 2024,
            month: 2,
          );

          const expectedFileName =
              'OnePage_February 2024_v1.0.0-20240315144530.md';

          expect(p.basename(file.path), equals(expectedFileName));
        });
      });
    });

    group('exportDateRange method', () {
      test('exports empty date range', () async {
        final startDate = DateTime(2024);
        final endDate = DateTime(2024, 1, 31);

        final file = await exporter.exportDateRange(
          entries: [],
          startDate: startDate,
          endDate: endDate,
        );

        final content = await file.readAsString();
        expect(content, contains('# January 2024'));
      });

      test('exports entries within date range', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 10),
            content: 'Within range',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 5),
            content: 'Also within',
          ),
          ExportDiary(
            date: DateTime(2023, 12, 31),
            content: 'Before range',
          ),
          ExportDiary(
            date: DateTime(2024, 2),
            content: 'After range',
          ),
        ];

        final file = await exporter.exportDateRange(
          entries: entries,
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        final content = await file.readAsString();

        expect(content, contains('Within range'));
        expect(content, contains('Also within'));
        expect(content, isNot(contains('Before range')));
        expect(content, isNot(contains('After range')));
      });

      test('includes entries on boundary dates', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024),
            content: 'Start date entry',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 31),
            content: 'End date entry',
          ),
        ];

        final file = await exporter.exportDateRange(
          entries: entries,
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        final content = await file.readAsString();

        expect(content, contains('Start date entry'));
        expect(content, contains('End date entry'));
      });

      test('generates title for same day range', () async {
        final date = DateTime(2024, 1, 15);

        final file = await exporter.exportDateRange(
          entries: [],
          startDate: date,
          endDate: date,
        );

        final content = await file.readAsString();
        expect(content, contains('# Mon, Jan 15, 2024'));
      });

      test('generates title for cross-month range', () async {
        final file = await exporter.exportDateRange(
          entries: [],
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 2, 15),
        );

        final content = await file.readAsString();
        expect(content, contains('# Jan 15, 2024 - Feb 15, 2024'));
      });

      test('generates correct filename for date range', () async {
        final now = DateTime(2024, 3, 15, 14, 45, 30);
        await withClock(Clock.fixed(now), () async {
          final file = await exporter.exportDateRange(
            entries: [],
            startDate: DateTime(2024, 1, 15),
            endDate: DateTime(2024, 2, 15),
          );

          const expectedFileName =
              'OnePage_Jan 15 2024 - Feb 15 2024_v1.0.0-20240315144530.md';

          expect(p.basename(file.path), equals(expectedFileName));
        });
      });

      test('sorts entries by date in range export', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2024, 1, 20),
            content: 'Second',
          ),
          ExportDiary(
            date: DateTime(2024, 1, 10),
            content: 'First',
          ),
        ];

        final file = await exporter.exportDateRange(
          entries: entries,
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        final content = await file.readAsString();
        final lines = content.split('\n');

        final firstIndex = lines.indexOf('First');
        final secondIndex = lines.indexOf('Second');

        expect(firstIndex, lessThan(secondIndex));
      });
    });

    group('edge cases', () {
      test('handles special characters in title', () async {
        final specialPackageInfo = PackageInfo(
          appName: r'One/Page\Test:App',
          packageName: 'com.example.onepage',
          version: '1.0.0',
          buildNumber: '1',
        );
        final specialExporter = MarkdownExporter(
          packageInfo: specialPackageInfo,
        );

        final file = await specialExporter.export(entries: []);

        final fileName = p.basename(file.path);
        expect(fileName, isNot(contains('/')));
        expect(fileName, isNot(contains(r'\')));
        expect(fileName, isNot(contains(':')));
      });

      test('preserves file path structure', () async {
        final file = await exporter.export(entries: []);

        expect(file.path, startsWith(tempDirPath));
        expect(file.path, endsWith('.md'));
      });
    });
  });
}
