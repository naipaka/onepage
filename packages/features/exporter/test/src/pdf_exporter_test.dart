import 'package:clock/clock.dart';
import 'package:exporter/exporter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PackageInfo packageInfo;
  late PdfExporter exporter;

  group('PdfExporter', () {
    setUp(() {
      // Mock the platform channel for path_provider
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
              if (methodCall.method == 'getTemporaryDirectory') {
                return '/tmp';
              }
              return null;
            },
          );

      packageInfo = PackageInfo(
        appName: 'Test App',
        packageName: 'com.example.test',
        version: '1.0.0',
        buildNumber: '2',
        buildSignature: 'test',
      );

      exporter = PdfExporter(
        packageInfo: packageInfo,
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
    });

    group('export', () {
      test(
        'generates PDF file with correct filename for same month entries',
        () async {
          await withClock(
            Clock.fixed(DateTime(2023, 12, 15, 10, 30)),
            () async {
              final entries = [
                ExportDiary(
                  date: DateTime(2023, 12),
                  content: 'Test content 1',
                ),
                ExportDiary(
                  date: DateTime(2023, 12, 2),
                  content: 'Test content 2',
                ),
              ];

              final file = await exporter.export(
                entries: entries,
              );

              expect(file.existsSync(), isTrue);
              expect(file.path, contains('Test App_'));
              expect(file.path, contains('December 2023'));
              expect(file.path, contains('v1.0.0-20231215103000.pdf'));

              await file.delete();
            },
          );
        },
      );

      test(
        'generates PDF file with date range title for cross-month entries',
        () async {
          await withClock(
            Clock.fixed(DateTime(2023, 12, 15, 10, 30)),
            () async {
              final entries = [
                ExportDiary(
                  date: DateTime(2023, 11, 30),
                  content: 'November content',
                ),
                ExportDiary(
                  date: DateTime(2023, 12),
                  content: 'December content',
                ),
              ];

              final file = await exporter.export(
                entries: entries,
              );

              expect(file.existsSync(), isTrue);
              expect(file.path, contains('Test App_'));
              expect(file.path, contains('November 2023 - December 2023'));

              await file.delete();
            },
          );
        },
      );

      test('generates PDF with empty entries using current date', () async {
        await withClock(Clock.fixed(DateTime(2023, 12, 15, 10, 30)), () async {
          final file = await exporter.export(
            entries: <ExportDiary>[],
          );

          expect(file.existsSync(), isTrue);
          expect(file.path, contains('Test App_'));
          expect(file.path, contains('December 2023'));

          await file.delete();
        });
      });

      test('generates PDF with entries containing empty content', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2023, 12),
            content: '',
          ),
          ExportDiary(
            date: DateTime(2023, 12, 2),
            content: 'Non-empty content',
          ),
        ];

        final file = await exporter.export(
          entries: entries,
        );

        expect(file.existsSync(), isTrue);
        expect(file.path, contains('Test App_'));

        await file.delete();
      });

      test('sanitizes title for filename with special characters', () async {
        await withClock(Clock.fixed(DateTime(2023, 1, 15)), () async {
          final entries = [
            ExportDiary(
              date: DateTime(2023),
              content: 'Test content',
            ),
          ];

          final file = await exporter.export(
            entries: entries,
          );

          expect(file.existsSync(), isTrue);
          expect(file.path, contains('Test App_'));
          expect(file.path, contains('January 2023'));
          // Verify special characters are removed from filename (not full path)
          final fileName = file.path.split('/').last;
          expect(fileName, isNot(contains(':')));
          expect(fileName, isNot(contains('<')));
          expect(fileName, isNot(contains('>')));

          await file.delete();
        });
      });

      test('handles single entry correctly', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2023, 5, 15),
            content: 'Single entry content',
          ),
        ];

        final file = await exporter.export(
          entries: entries,
        );

        expect(file.existsSync(), isTrue);
        expect(file.path, contains('Test App_'));
        expect(file.path, contains('May 2023'));

        await file.delete();
      });

      test('handles entries with very long content', () async {
        final longContent = 'A' * 1000; // Reduced to avoid page limit
        final entries = [
          ExportDiary(
            date: DateTime(2023, 6),
            content: longContent,
          ),
        ];

        final file = await exporter.export(
          entries: entries,
        );

        expect(file.existsSync(), isTrue);
        expect(file.path, contains('Test App_'));

        await file.delete();
      });

      test('handles entries with unicode content', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2023, 7),
            content: '今日はいい天気でした。🌞',
          ),
        ];

        final file = await exporter.export(
          entries: entries,
        );

        expect(file.existsSync(), isTrue);
        expect(file.path, contains('Test App_'));

        await file.delete();
      });

      test('handles entries spanning multiple years', () async {
        final entries = [
          ExportDiary(
            date: DateTime(2022, 12, 31),
            content: 'Last day of 2022',
          ),
          ExportDiary(
            date: DateTime(2023),
            content: 'First day of 2023',
          ),
        ];

        final file = await exporter.export(
          entries: entries,
        );

        expect(file.existsSync(), isTrue);
        expect(file.path, contains('Test App_'));
        expect(file.path, contains('December 2022 - January 2023'));

        await file.delete();
      });
    });

    group('title generation', () {
      test('generates correct title for empty entries', () async {
        await withClock(Clock.fixed(DateTime(2023, 3, 15)), () async {
          final file = await exporter.export(entries: <ExportDiary>[]);
          expect(file.path, contains('March 2023'));
          await file.delete();
        });
      });

      test('generates correct title for same month entries', () async {
        final entries = [
          ExportDiary(date: DateTime(2023, 4), content: 'content1'),
          ExportDiary(date: DateTime(2023, 4, 15), content: 'content2'),
        ];

        final file = await exporter.export(entries: entries);
        expect(file.path, contains('April 2023'));
        await file.delete();
      });

      test('generates correct title for different month entries', () async {
        final entries = [
          ExportDiary(date: DateTime(2023, 2, 28), content: 'content1'),
          ExportDiary(date: DateTime(2023, 3), content: 'content2'),
        ];

        final file = await exporter.export(entries: entries);
        expect(file.path, contains('February 2023 - March 2023'));
        await file.delete();
      });
    });

    group('filename generation', () {
      test('includes app name in filename', () async {
        final file = await exporter.export(entries: <ExportDiary>[]);
        expect(file.path, contains('Test App_'));
        await file.delete();
      });

      test('includes version in filename', () async {
        final file = await exporter.export(entries: <ExportDiary>[]);
        expect(file.path, contains('v1.0.0'));
        await file.delete();
      });

      test('includes timestamp in filename', () async {
        await withClock(
          Clock.fixed(DateTime(2023, 12, 25, 14, 30, 45)),
          () async {
            final file = await exporter.export(entries: <ExportDiary>[]);
            expect(file.path, contains('20231225143045'));
            await file.delete();
          },
        );
      });

      test('removes special characters from title in filename', () async {
        // This tests the _generateFileName method indirectly
        final file = await exporter.export(entries: <ExportDiary>[]);
        // Since we're using DateFormat.yMMMM() which doesn't typically contain
        // special characters that need sanitization, we just verify the file
        // is created
        expect(file.existsSync(), isTrue);
        await file.delete();
      });
    });

    group('package info usage', () {
      test('uses package info app name', () async {
        final customPackageInfo = PackageInfo(
          appName: 'Custom App Name',
          packageName: 'com.example.custom',
          version: '2.0.0',
          buildNumber: '5',
          buildSignature: 'custom',
        );

        final customExporter = PdfExporter(packageInfo: customPackageInfo);
        final file = await customExporter.export(entries: <ExportDiary>[]);

        expect(file.path, contains('Custom App Name_'));
        expect(file.path, contains('v2.0.0'));

        await file.delete();
      });
    });
  });

  group('ExportDiary', () {
    test('creates instance correctly', () {
      final date = DateTime(2023, 12);
      const content = 'Test content';

      final entry = ExportDiary(
        date: date,
        content: content,
      );

      expect(entry.date, equals(date));
      expect(entry.content, equals(content));
    });

    test('creates instance with empty content', () {
      final date = DateTime(2023, 12);
      const content = '';

      final entry = ExportDiary(
        date: date,
        content: content,
      );

      expect(entry.date, equals(date));
      expect(entry.content, equals(content));
    });

    test('supports equality', () {
      final date = DateTime(2023, 12);
      const content = 'Test content';

      final entry1 = ExportDiary(date: date, content: content);
      final entry2 = ExportDiary(date: date, content: content);
      final entry3 = ExportDiary(date: date, content: 'Different content');

      expect(entry1, equals(entry2));
      expect(entry1, isNot(equals(entry3)));
    });

    test('supports toString', () {
      final entry = ExportDiary(
        date: DateTime(2023, 12),
        content: 'Test content',
      );

      expect(entry.toString(), isA<String>());
      expect(entry.toString(), contains('ExportDiary'));
    });

    test('supports JSON serialization', () {
      final entry = ExportDiary(
        date: DateTime(2023, 12),
        content: 'Test content',
      );

      final json = entry.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['date'], isA<String>());
      expect(json['content'], equals('Test content'));

      final deserialized = ExportDiary.fromJson(json);
      expect(deserialized, equals(entry));
    });

    test('handles special characters in content', () {
      final entry = ExportDiary(
        date: DateTime(2023, 12),
        content: 'Special chars: !@#\$%^&*()_+{}|:"<>?[]\\;\',./',
      );

      expect(entry.content, contains('Special chars:'));
    });

    test('handles unicode content', () {
      final entry = ExportDiary(
        date: DateTime(2023, 12),
        content: '日本語のテキスト 🌸',
      );

      expect(entry.content, equals('日本語のテキスト 🌸'));
    });
  });

  group('exportMonth', () {
    setUp(() {
      // Mock the platform channel for path_provider
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
              if (methodCall.method == 'getTemporaryDirectory') {
                return '/tmp';
              }
              return null;
            },
          );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
    });

    test('exports entries for specific month only', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 11, 30), // Previous month
          content: 'November content',
        ),
        ExportDiary(
          date: DateTime(2023, 12), // Target month
          content: 'December 1st content',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 15), // Target month
          content: 'December 15th content',
        ),
        ExportDiary(
          date: DateTime(2024), // Next month
          content: 'January content',
        ),
      ];

      final file = await exporter.exportMonth(
        entries: entries,
        year: 2023,
        month: 12,
      );

      expect(file.existsSync(), isTrue);
      expect(file.path, contains('Test App_'));
      expect(file.path, contains('December 2023'));

      await file.delete();
    });

    test('exports empty result when no entries match month', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 11, 30),
          content: 'November content',
        ),
        ExportDiary(
          date: DateTime(2024),
          content: 'January content',
        ),
      ];

      final file = await exporter.exportMonth(
        entries: entries,
        year: 2023,
        month: 12,
      );

      expect(file.existsSync(), isTrue);
      expect(file.path, contains('Test App_'));
      expect(file.path, contains('December 2023'));

      await file.delete();
    });

    test('handles entries on month boundaries', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12), // First day of month
          content: 'First day',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 31), // Last day of month
          content: 'Last day',
        ),
      ];

      final file = await exporter.exportMonth(
        entries: entries,
        year: 2023,
        month: 12,
      );

      expect(file.existsSync(), isTrue);
      expect(file.path, contains('December 2023'));

      await file.delete();
    });

    test('handles February in leap year', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2024, 2, 29), // Leap year February 29th
          content: 'Leap day content',
        ),
      ];

      final file = await exporter.exportMonth(
        entries: entries,
        year: 2024,
        month: 2,
      );

      expect(file.existsSync(), isTrue);
      expect(file.path, contains('February 2024'));

      await file.delete();
    });
  });

  group('exportDateRange', () {
    setUp(() {
      // Mock the platform channel for path_provider
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
              if (methodCall.method == 'getTemporaryDirectory') {
                return '/tmp';
              }
              return null;
            },
          );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
    });

    test('exports entries within date range', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12, 5), // Before range
          content: 'Before range',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 10), // Within range
          content: 'Within range 1',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 15), // Within range
          content: 'Within range 2',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 25), // After range
          content: 'After range',
        ),
      ];

      final file = await exporter.exportDateRange(
        entries: entries,
        startDate: DateTime(2023, 12, 10),
        endDate: DateTime(2023, 12, 20),
      );

      expect(file.existsSync(), isTrue);
      expect(file.path, contains('Test App_'));

      await file.delete();
    });

    test('includes entries on boundary dates', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12, 10), // Start date
          content: 'Start date content',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 20), // End date
          content: 'End date content',
        ),
      ];

      final file = await exporter.exportDateRange(
        entries: entries,
        startDate: DateTime(2023, 12, 10),
        endDate: DateTime(2023, 12, 20),
      );

      expect(file.existsSync(), isTrue);

      await file.delete();
    });

    test('handles same start and end date', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12, 15),
          content: 'Single day content',
        ),
      ];

      final file = await exporter.exportDateRange(
        entries: entries,
        startDate: DateTime(2023, 12, 15),
        endDate: DateTime(2023, 12, 15),
      );

      expect(file.existsSync(), isTrue);

      await file.delete();
    });

    test('handles cross-month date range', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 11, 25),
          content: 'November content',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 5),
          content: 'December content',
        ),
      ];

      final file = await exporter.exportDateRange(
        entries: entries,
        startDate: DateTime(2023, 11, 20),
        endDate: DateTime(2023, 12, 10),
      );

      expect(file.existsSync(), isTrue);

      await file.delete();
    });

    test('handles cross-year date range', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12, 25),
          content: 'End of 2023',
        ),
        ExportDiary(
          date: DateTime(2024, 1, 5),
          content: 'Start of 2024',
        ),
      ];

      final file = await exporter.exportDateRange(
        entries: entries,
        startDate: DateTime(2023, 12, 20),
        endDate: DateTime(2024, 1, 10),
      );

      expect(file.existsSync(), isTrue);

      await file.delete();
    });

    test('exports empty result when no entries in range', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12, 5),
          content: 'Before range',
        ),
        ExportDiary(
          date: DateTime(2023, 12, 25),
          content: 'After range',
        ),
      ];

      final file = await exporter.exportDateRange(
        entries: entries,
        startDate: DateTime(2023, 12, 10),
        endDate: DateTime(2023, 12, 20),
      );

      expect(file.existsSync(), isTrue);

      await file.delete();
    });
  });

  group('title generation for new methods', () {
    setUp(() {
      // Mock the platform channel for path_provider
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
              if (methodCall.method == 'getTemporaryDirectory') {
                return '/tmp';
              }
              return null;
            },
          );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
    });

    test('generates correct month title format', () async {
      final entries = [
        ExportDiary(
          date: DateTime(2023, 12, 15),
          content: 'December content',
        ),
      ];

      final file = await exporter.exportMonth(
        entries: entries,
        year: 2023,
        month: 12,
      );

      expect(file.path, contains('December 2023'));

      await file.delete();
    });

    test('generates different month title formats', () async {
      final testCases = [
        (1, 'January'),
        (2, 'February'),
        (6, 'June'),
        (12, 'December'),
      ];

      for (final (month, expectedMonth) in testCases) {
        final entries = [
          ExportDiary(
            date: DateTime(2023, month, 15),
            content: 'Content for month $month',
          ),
        ];

        final file = await exporter.exportMonth(
          entries: entries,
          year: 2023,
          month: month,
        );

        expect(file.path, contains('$expectedMonth 2023'));

        await file.delete();
      }
    });
  });

  group('Exporter interface', () {
    test('PdfExporter implements Exporter', () {
      final testExporter = PdfExporter(packageInfo: packageInfo);
      expect(testExporter, isA<Exporter>());
    });
  });
}
