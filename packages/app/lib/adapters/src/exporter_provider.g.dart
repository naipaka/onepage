// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'exporter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// {@macro exporter.PdfExporter}

@ProviderFor(pdfExporter)
final pdfExporterProvider = PdfExporterProvider._();

/// {@macro exporter.PdfExporter}

final class PdfExporterProvider
    extends $FunctionalProvider<PdfExporter, PdfExporter, PdfExporter>
    with $Provider<PdfExporter> {
  /// {@macro exporter.PdfExporter}
  PdfExporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pdfExporterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pdfExporterHash();

  @$internal
  @override
  $ProviderElement<PdfExporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PdfExporter create(Ref ref) {
    return pdfExporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PdfExporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PdfExporter>(value),
    );
  }
}

String _$pdfExporterHash() => r'6891db85a858a2322381174bb84e62746ec92a1b';

/// {@macro exporter.CsvExporter}

@ProviderFor(csvExporter)
final csvExporterProvider = CsvExporterProvider._();

/// {@macro exporter.CsvExporter}

final class CsvExporterProvider
    extends $FunctionalProvider<CsvExporter, CsvExporter, CsvExporter>
    with $Provider<CsvExporter> {
  /// {@macro exporter.CsvExporter}
  CsvExporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'csvExporterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$csvExporterHash();

  @$internal
  @override
  $ProviderElement<CsvExporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CsvExporter create(Ref ref) {
    return csvExporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CsvExporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CsvExporter>(value),
    );
  }
}

String _$csvExporterHash() => r'560bb7bc3ecc41ec46299412ac4e726f5908f3f4';

/// {@macro exporter.MarkdownExporter}

@ProviderFor(markdownExporter)
final markdownExporterProvider = MarkdownExporterProvider._();

/// {@macro exporter.MarkdownExporter}

final class MarkdownExporterProvider
    extends
        $FunctionalProvider<
          MarkdownExporter,
          MarkdownExporter,
          MarkdownExporter
        >
    with $Provider<MarkdownExporter> {
  /// {@macro exporter.MarkdownExporter}
  MarkdownExporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markdownExporterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markdownExporterHash();

  @$internal
  @override
  $ProviderElement<MarkdownExporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MarkdownExporter create(Ref ref) {
    return markdownExporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkdownExporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkdownExporter>(value),
    );
  }
}

String _$markdownExporterHash() => r'1bd93dff6804e9de22aa4123f6def7a6715d534d';
