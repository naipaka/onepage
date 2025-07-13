import 'package:exporter/exporter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CsvExporter', () {
    late CsvExporter exporter;

    setUp(() {
      exporter = const CsvExporter();
    });

    test('is an instance of Exporter', () {
      expect(exporter, isA<Exporter>());
    });

    group('export method', () {
      test('throws UnimplementedError', () async {
        final entries = [
          DiaryEntry(
            date: DateTime(2024),
            content: 'Test entry',
          ),
        ];

        expect(
          () => exporter.export(entries: entries),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('throws UnimplementedError with empty entries', () async {
        expect(
          () => exporter.export(entries: []),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('exportMonth method', () {
      test('throws UnimplementedError', () async {
        final entries = [
          DiaryEntry(
            date: DateTime(2024, 1, 15),
            content: 'Test entry',
          ),
        ];

        expect(
          () => exporter.exportMonth(
            entries: entries,
            year: 2024,
            month: 1,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('throws UnimplementedError with empty entries', () async {
        expect(
          () => exporter.exportMonth(
            entries: [],
            year: 2024,
            month: 1,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('exportDateRange method', () {
      test('throws UnimplementedError', () async {
        final entries = [
          DiaryEntry(
            date: DateTime(2024, 1, 15),
            content: 'Test entry',
          ),
        ];

        expect(
          () => exporter.exportDateRange(
            entries: entries,
            startDate: DateTime(2024),
            endDate: DateTime(2024, 1, 31),
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('throws UnimplementedError with empty entries', () async {
        expect(
          () => exporter.exportDateRange(
            entries: [],
            startDate: DateTime(2024),
            endDate: DateTime(2024, 1, 31),
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('const constructor', () {
      test('can be created as const', () {
        const exporter1 = CsvExporter();
        const exporter2 = CsvExporter();

        expect(identical(exporter1, exporter2), isTrue);
      });
    });
  });
}
