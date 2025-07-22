import 'package:exporter/exporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider_utils/provider_utils.dart';

void main() {
  group('ExporterProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          packageInfoProvider.overrideWithValue(
            PackageInfo(
              appName: 'OnePage',
              packageName: 'jp.co.altive.onepage',
              version: '1.0.0',
              buildNumber: '1',
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('pdfExporterProvider provides PdfExporter instance', () {
      final pdfExporter = container.read(pdfExporterProvider);
      expect(pdfExporter, isA<PdfExporter>());
    });

    test('csvExporterProvider provides CsvExporter instance', () {
      final csvExporter = container.read(csvExporterProvider);
      expect(csvExporter, isA<CsvExporter>());
    });

    test('markdownExporterProvider provides MarkdownExporter instance', () {
      final markdownExporter = container.read(markdownExporterProvider);
      expect(markdownExporter, isA<MarkdownExporter>());
    });

    test('exporters use packageInfo dependency', () {
      final pdfExporter = container.read(pdfExporterProvider);
      final csvExporter = container.read(csvExporterProvider);
      final markdownExporter = container.read(markdownExporterProvider);

      expect(pdfExporter, isA<PdfExporter>());
      expect(csvExporter, isA<CsvExporter>());
      expect(markdownExporter, isA<MarkdownExporter>());
    });
  });
}
