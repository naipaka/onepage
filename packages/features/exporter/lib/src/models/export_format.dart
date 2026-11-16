import '../untranslated_texts.dart';

/// {@template exporter.ExportFormat}
/// Represents the available export formats for diary entries.
/// {@endtemplate}
enum ExportFormat {
  /// A PDF document.
  pdf(displayName: UntranslatedTexts.pdfName, fileExtension: '.pdf'),

  /// A CSV file.
  csv(displayName: UntranslatedTexts.csvName, fileExtension: '.csv'),

  /// A Markdown file.
  markdown(
    displayName: UntranslatedTexts.markdownName,
    fileExtension: '.md',
  );

  /// {@macro exporter.ExportFormat}
  new({required this.displayName, required this.fileExtension});

  /// The display name for this export format.
  final String displayName;

  /// The file extension for this export format.
  final String fileExtension;
}
