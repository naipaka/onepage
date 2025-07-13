import 'package:exporter/exporter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pdf_export_provider.g.dart';

/// {@macro exporter.PdfExporter}
@riverpod
PdfExporter pdfExporter(Ref ref) {
  return PdfExporter(
    packageInfo: ref.watch(packageInfoProvider),
  );
}
