# Exporter

A Flutter package for exporting diary entries to various formats with extensible architecture.

## Features

- Export diary entries to multiple formats (currently PDF)
- Extensible architecture with interface-based design
- App-consistent design and styling
- Share generated export files
- Support for Japanese and English text
- Automatic title generation from entry dates

## Getting Started

Add this package to your dependencies:

```yaml
dependencies:
  exporter:
    path: packages/features/exporter/
```

## Usage

### PDF Export

Create a `PdfExporter` and use it to export diary entries:

```dart
final pdfExporter = PdfExporter(
  packageInfo: packageInfo,
);

final entries = [
  DiaryEntry(
    date: DateTime(2024, 6, 1),
    content: 'Today was a good day...',
  ),
  DiaryEntry(
    date: DateTime(2024, 6, 2),
    content: 'Another diary entry...',
  ),
];

final pdfFile = await pdfExporter.export(
  entries: entries,
);

// Share the generated PDF
await Share.shareXFiles([XFile(pdfFile.path)]);
```

### Extending with New Export Formats

To add support for new export formats, implement the `Exporter` interface:

```dart
class CsvExporter implements Exporter {
  @override
  Future<File> export({required List<DiaryEntry> entries}) async {
    // Implementation for CSV export
  }
}
```

## Architecture

The package follows an interface-based architecture:

- `Exporter`: Interface defining the contract for all exporters
- `PdfExporter`: Implementation for PDF export
- `DiaryEntry`: Data model for diary entries

This design allows for easy extension with new export formats while maintaining consistency across implementations.