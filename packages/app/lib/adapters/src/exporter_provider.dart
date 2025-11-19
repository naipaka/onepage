import 'package:exporter/exporter.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exporter_provider.g.dart';

/// {@macro exporter.PdfExporter}
@riverpod
PdfExporter pdfExporter(Ref ref) {
  return PdfExporter(
    packageInfo: ref.watch(packageInfoProvider),
  );
}

/// {@macro exporter.CsvExporter}
@riverpod
CsvExporter csvExporter(Ref ref) {
  return CsvExporter(
    packageInfo: ref.watch(packageInfoProvider),
  );
}

/// {@macro exporter.MarkdownExporter}
@riverpod
MarkdownExporter markdownExporter(Ref ref) {
  return MarkdownExporter(
    packageInfo: ref.watch(packageInfoProvider),
  );
}
