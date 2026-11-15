/// {@template exporter.UntranslatedTexts}
/// The texts of the exported files and formats that stay the same in every
/// language.
/// {@endtemplate}
abstract final class UntranslatedTexts {
  /// The column names of the CSV file. Spreadsheets and other tools read them
  /// as keys, so they stay in English.
  static const csvHeader = 'Date,Content';

  /// The title of the PDF file, which is the name of the app.
  static const pdfTitle = 'One Page Diary';

  /// The name of the PDF format, which every language calls the same.
  static const pdfName = 'PDF';

  /// The name of the CSV format, which every language calls the same.
  static const csvName = 'CSV';

  /// The name of the Markdown format, which every language calls the same.
  static const markdownName = 'Markdown';
}
