import 'package:exporter/exporter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExportFormat', () {
    group('factory constructors', () {
      test('creates PDF format', () {
        const format = ExportFormat.pdf();
        expect(format, isA<ExportFormat>());
      });

      test('creates CSV format', () {
        const format = ExportFormat.csv();
        expect(format, isA<ExportFormat>());
      });

      test('creates Markdown format', () {
        const format = ExportFormat.markdown();
        expect(format, isA<ExportFormat>());
      });
    });

    group('displayName', () {
      test('returns correct display name for PDF', () {
        const format = ExportFormat.pdf();
        expect(format.displayName, equals('PDF'));
      });

      test('returns correct display name for CSV', () {
        const format = ExportFormat.csv();
        expect(format.displayName, equals('CSV'));
      });

      test('returns correct display name for Markdown', () {
        const format = ExportFormat.markdown();
        expect(format.displayName, equals('Markdown'));
      });
    });

    group('fileExtension', () {
      test('returns correct file extension for PDF', () {
        const format = ExportFormat.pdf();
        expect(format.fileExtension, equals('.pdf'));
      });

      test('returns correct file extension for CSV', () {
        const format = ExportFormat.csv();
        expect(format.fileExtension, equals('.csv'));
      });

      test('returns correct file extension for Markdown', () {
        const format = ExportFormat.markdown();
        expect(format.fileExtension, equals('.md'));
      });
    });

    group('equality', () {
      test('PDF formats are equal', () {
        const format1 = ExportFormat.pdf();
        const format2 = ExportFormat.pdf();
        expect(format1, equals(format2));
        expect(format1.hashCode, equals(format2.hashCode));
      });

      test('CSV formats are equal', () {
        const format1 = ExportFormat.csv();
        const format2 = ExportFormat.csv();
        expect(format1, equals(format2));
        expect(format1.hashCode, equals(format2.hashCode));
      });

      test('Markdown formats are equal', () {
        const format1 = ExportFormat.markdown();
        const format2 = ExportFormat.markdown();
        expect(format1, equals(format2));
        expect(format1.hashCode, equals(format2.hashCode));
      });

      test('different formats are not equal', () {
        const pdfFormat = ExportFormat.pdf();
        const csvFormat = ExportFormat.csv();
        const markdownFormat = ExportFormat.markdown();
        
        expect(pdfFormat, isNot(equals(csvFormat)));
        expect(pdfFormat, isNot(equals(markdownFormat)));
        expect(csvFormat, isNot(equals(markdownFormat)));
      });
    });

    group('toString', () {
      test('PDF format has string representation', () {
        const format = ExportFormat.pdf();
        expect(format.toString(), isNotEmpty);
        expect(format.toString(), contains('ExportFormat'));
      });

      test('CSV format has string representation', () {
        const format = ExportFormat.csv();
        expect(format.toString(), isNotEmpty);
        expect(format.toString(), contains('ExportFormat'));
      });

      test('Markdown format has string representation', () {
        const format = ExportFormat.markdown();
        expect(format.toString(), isNotEmpty);
        expect(format.toString(), contains('ExportFormat'));
      });
    });

    group('when method', () {
      test('PDF format executes PDF callback', () {
        const format = ExportFormat.pdf();
        final result = format.when(
          pdf: () => 'PDF result',
          csv: () => 'CSV result',
          markdown: () => 'Markdown result',
        );
        expect(result, equals('PDF result'));
      });

      test('CSV format executes CSV callback', () {
        const format = ExportFormat.csv();
        final result = format.when(
          pdf: () => 'PDF result',
          csv: () => 'CSV result',
          markdown: () => 'Markdown result',
        );
        expect(result, equals('CSV result'));
      });

      test('Markdown format executes Markdown callback', () {
        const format = ExportFormat.markdown();
        final result = format.when(
          pdf: () => 'PDF result',
          csv: () => 'CSV result',
          markdown: () => 'Markdown result',
        );
        expect(result, equals('Markdown result'));
      });
    });

    group('maybeWhen method', () {
      test('PDF format executes PDF callback with orElse', () {
        const format = ExportFormat.pdf();
        final result = format.maybeWhen(
          pdf: () => 'PDF result',
          orElse: () => 'Default result',
        );
        expect(result, equals('PDF result'));
      });

      test('CSV format falls back to orElse when no CSV callback', () {
        const format = ExportFormat.csv();
        final result = format.maybeWhen(
          pdf: () => 'PDF result',
          orElse: () => 'Default result',
        );
        expect(result, equals('Default result'));
      });

      test(
        'Markdown format falls back to orElse when no Markdown callback',
        () {
          const format = ExportFormat.markdown();
          final result = format.maybeWhen(
            pdf: () => 'PDF result',
            orElse: () => 'Default result',
          );
          expect(result, equals('Default result'));
        },
      );
    });
  });
}
