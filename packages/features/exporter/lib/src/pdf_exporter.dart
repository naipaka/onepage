import 'dart:io';

import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'export_period.dart';
import 'exporter.dart';
import 'models/models.dart';
import 'untranslated_texts.dart';

/// {@template exporter.PdfExporter}
/// Exports diary entries to PDF format.
/// {@endtemplate}
class PdfExporter extends Exporter {
  /// {@macro exporter.PdfExporter}
  const new({
    required this.packageInfo,
    required this.locale,
    required this.noEntryText,
  });

  /// Package information for metadata.
  final PackageInfo packageInfo;

  /// The locale of the dates, in the language of the app.
  final String locale;

  /// The text for a day without an entry, in the language of the app.
  final String noEntryText;

  pw.TextStyle _getTextStyle({
    required pw.Font baseFont,
    required pw.Font jpFont,
    double fontSize = 16,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor? color,
    double? lineSpacing,
  }) {
    return pw.TextStyle(
      font: baseFont,
      fontFallback: [jpFont],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      lineSpacing: lineSpacing,
    );
  }

  /// Exports diary entries as a PDF file.
  @override
  Future<File> export({
    required List<ExportDiary> entries,
  }) async {
    final pdf = pw.Document();

    final period = ExportPeriod.ofEntries(entries);
    await _addDiariesPage(pdf, entries, period.title(locale));

    final fileName = _generateFileName(period);
    final file = await _saveToFile(pdf, fileName);

    return file;
  }

  /// Exports diary entries for a specific month as a PDF file.
  @override
  Future<File> exportMonth({
    required List<ExportDiary> entries,
    required int year,
    required int month,
  }) async {
    final filteredEntries = entries.where((entry) {
      return entry.date.year == year && entry.date.month == month;
    }).toList();

    final pdf = pw.Document();
    final period = ExportPeriod.month(year, month);
    await _addDiariesPageForMonth(
      pdf,
      filteredEntries,
      period.title(locale),
      year,
      month,
    );

    final fileName = _generateFileName(period);
    final file = await _saveToFile(pdf, fileName);

    return file;
  }

  /// Exports diary entries for a specific date range as a PDF file.
  @override
  Future<File> exportDateRange({
    required List<ExportDiary> entries,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final filteredEntries = entries.where((entry) {
      final entryDate = entry.date;
      return entryDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    final pdf = pw.Document();
    final period = ExportPeriod.dateRange(startDate, endDate);
    await _addDiariesPage(pdf, filteredEntries, period.title(locale));

    final fileName = _generateFileName(period);
    final file = await _saveToFile(pdf, fileName);

    return file;
  }

  Future<void> _addDiariesPage(
    pw.Document pdf,
    List<ExportDiary> entries,
    String title,
  ) async {
    final baseFont = await PdfGoogleFonts.notoSansRegular();
    final jpFont = await PdfGoogleFonts.notoSansJPRegular();
    final baseBoldFont = await PdfGoogleFonts.notoSansBold();
    final jpBoldFont = await PdfGoogleFonts.notoSansJPBold();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _buildHeader(title, baseBoldFont, jpBoldFont),
          pw.SizedBox(height: 20),
          ...entries.map(
            (entry) => _buildExportDiary(
              entry,
              baseFont,
              jpFont,
              baseBoldFont,
              jpBoldFont,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addDiariesPageForMonth(
    pw.Document pdf,
    List<ExportDiary> entries,
    String title,
    int year,
    int month,
  ) async {
    final baseFont = await PdfGoogleFonts.notoSansRegular();
    final jpFont = await PdfGoogleFonts.notoSansJPRegular();
    final baseBoldFont = await PdfGoogleFonts.notoSansBold();
    final jpBoldFont = await PdfGoogleFonts.notoSansJPBold();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _buildHeader(title, baseBoldFont, jpBoldFont),
          pw.SizedBox(height: 20),
          _buildCompleteMonthContent(
            entries,
            year,
            month,
            baseFont,
            jpFont,
            baseBoldFont,
            jpBoldFont,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHeader(
    String title,
    pw.Font baseBoldFont,
    pw.Font jpBoldFont,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          UntranslatedTexts.pdfTitle,
          style: _getTextStyle(
            baseFont: baseBoldFont,
            jpFont: jpBoldFont,
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          title,
          style: _getTextStyle(
            baseFont: baseBoldFont,
            jpFont: jpBoldFont,
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildExportDiary(
    ExportDiary entry,
    pw.Font baseFont,
    pw.Font jpFont,
    pw.Font baseBoldFont,
    pw.Font jpBoldFont,
  ) {
    final dateFormat = DateFormat.yMMMEd(locale);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            dateFormat.format(entry.date),
            style: _getTextStyle(
              baseFont: baseBoldFont,
              jpFont: jpBoldFont,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            entry.content.isEmpty ? noEntryText : entry.content,
            style: _getTextStyle(
              baseFont: baseFont,
              jpFont: jpFont,
              fontSize: 10,
              lineSpacing: 1.5,
            ),
          ),
          pw.Divider(),
        ],
      ),
    );
  }

  pw.Widget _buildCompleteMonthContent(
    List<ExportDiary> entries,
    int year,
    int month,
    pw.Font baseFont,
    pw.Font jpFont,
    pw.Font baseBoldFont,
    pw.Font jpBoldFont,
  ) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final dateFormat = DateFormat.yMMMEd(locale);

    final entryMap = <int, ExportDiary>{};
    for (final entry in entries) {
      if (entry.date.year == year && entry.date.month == month) {
        entryMap[entry.date.day] = entry;
      }
    }

    final dayWidgets = <pw.Widget>[];
    for (var index = 0; index < daysInMonth; index++) {
      final day = index + 1;
      final date = DateTime(year, month, day);
      final entry = entryMap[day];

      dayWidgets.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                dateFormat.format(date),
                style: _getTextStyle(
                  baseFont: baseBoldFont,
                  jpFont: jpBoldFont,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                entry?.content.isEmpty == false ? entry!.content : noEntryText,
                style: _getTextStyle(
                  baseFont: baseFont,
                  jpFont: jpFont,
                  fontSize: 10,
                  lineSpacing: 1.5,
                  color: entry?.content.isEmpty == false
                      ? PdfColors.black
                      : PdfColors.grey400,
                ),
              ),
              pw.Divider(),
            ],
          ),
        ),
      );
    }

    return pw.Column(children: dayWidgets);
  }

  String _generateFileName(ExportPeriod period) {
    final appName = packageInfo.appName;
    final version = packageInfo.version;
    final timestamp = DateFormat('yyyyMMddHHmmss').format(
      clock.now(),
    );

    return '${appName}_${period.fileNamePart}_v$version-$timestamp.pdf';
  }

  Future<File> _saveToFile(pw.Document pdf, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(p.join(tempDir.path, fileName));

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
