import 'package:exporter/exporter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExportFormat', () {
    group('displayName', () {
      test('returns correct display name for PDF', () {
        expect(ExportFormat.pdf.displayName, equals('PDF'));
      });

      test('returns correct display name for CSV', () {
        expect(ExportFormat.csv.displayName, equals('CSV'));
      });

      test('returns correct display name for Markdown', () {
        expect(ExportFormat.markdown.displayName, equals('Markdown'));
      });
    });

    group('fileExtension', () {
      test('returns correct file extension for PDF', () {
        expect(ExportFormat.pdf.fileExtension, equals('.pdf'));
      });

      test('returns correct file extension for CSV', () {
        expect(ExportFormat.csv.fileExtension, equals('.csv'));
      });

      test('returns correct file extension for Markdown', () {
        expect(ExportFormat.markdown.fileExtension, equals('.md'));
      });
    });
  });
}
