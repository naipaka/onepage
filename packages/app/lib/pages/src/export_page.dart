import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:exporter/exporter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:haptics/haptics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:intl/intl.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme/theme.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';

/// {@template onepage.ExportPage}
/// Page for exporting diary entries to various formats.
/// {@endtemplate}
class ExportPage extends HookConsumerWidget {
  /// {@macro onepage.ExportPage}
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colorScheme = context.colorScheme;
    final pdfExporter = ref.watch(pdfExporterProvider);
    final csvExporter = ref.watch(csvExporterProvider);
    final markdownExporter = ref.watch(markdownExporterProvider);
    final dbClient = ref.watch(dbClientProvider);
    final haptics = ref.watch(hapticsProvider);
    
    final selectedFormat = useState(const ExportFormat.pdf());
    final now = clock.now();
    final selectedYear = useState(now.year);
    final selectedMonth = useState(now.month);
    
    VoidCallback? onExportPressed;
    if (selectedFormat.value == const ExportFormat.pdf() ||
        selectedFormat.value == const ExportFormat.csv() ||
        selectedFormat.value == const ExportFormat.markdown()) {
      onExportPressed = () {
        haptics.buttonTapFeedback();
        _export(
          ref: ref,
          context: context,
          selectedYear: selectedYear.value,
          selectedMonth: selectedMonth.value,
          dbClient: dbClient,
          pdfExporter: pdfExporter,
          csvExporter: csvExporter,
          markdownExporter: markdownExporter,
          haptics: haptics,
          t: t,
          format: selectedFormat.value,
        );
      };
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(t.export.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BodyLargeText(
                t.export.formatSelection,
                fontWeight: FontWeight.w600,
              ),
              const Gap(12),
              SegmentedButton<ExportFormat>(
                style: SegmentedButton.styleFrom(
                  side: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: const ExportFormat.pdf(),
                    label: Text(const ExportFormat.pdf().displayName),
                  ),
                  ButtonSegment(
                    value: const ExportFormat.csv(),
                    label: Text(const ExportFormat.csv().displayName),
                  ),
                  ButtonSegment(
                    value: const ExportFormat.markdown(),
                    label: Text(
                      const ExportFormat.markdown().displayName,
                    ),
                  ),
                ],
                selected: {selectedFormat.value},
                onSelectionChanged: (formats) {
                  selectedFormat.value = formats.first;
                },
              ),
              const Gap(24),
              BodyLargeText(
                t.export.monthSelection,
                fontWeight: FontWeight.w600,
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelMediumText(t.export.year),
                        const Gap(4),
                        if (Platform.isIOS)
                          _buildIOSYearPicker(
                            context,
                            selectedYear,
                            selectedMonth,
                            colorScheme,
                          )
                        else
                          _buildAndroidYearDropdown(
                            context,
                            selectedYear,
                            selectedMonth,
                            colorScheme,
                          ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelMediumText(t.export.month),
                        const Gap(4),
                        if (Platform.isIOS)
                          _buildIOSMonthPicker(
                            context,
                            selectedYear,
                            selectedMonth,
                            colorScheme,
                          )
                        else
                          _buildAndroidMonthDropdown(
                            context,
                            selectedYear,
                            selectedMonth,
                            colorScheme,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(32),
              FilledButton(
                onPressed: onExportPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.download),
                    const Gap(8),
                    Text(t.export.actions.export),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _export({
    required WidgetRef ref,
    required BuildContext context,
    required int selectedYear,
    required int selectedMonth,
    required DbClient dbClient,
    required PdfExporter pdfExporter,
    required CsvExporter csvExporter,
    required MarkdownExporter markdownExporter,
    required Haptics haptics,
    required Translations t,
    required ExportFormat format,
  }) {
    unawaited(
      _performExport(
        ref: ref,
        context: context,
        selectedYear: selectedYear,
        selectedMonth: selectedMonth,
        dbClient: dbClient,
        pdfExporter: pdfExporter,
        csvExporter: csvExporter,
        markdownExporter: markdownExporter,
        haptics: haptics,
        t: t,
        format: format,
      ),
    );
  }

  Future<void> _performExport({
    required WidgetRef ref,
    required BuildContext context,
    required int selectedYear,
    required int selectedMonth,
    required DbClient dbClient,
    required PdfExporter pdfExporter,
    required CsvExporter csvExporter,
    required MarkdownExporter markdownExporter,
    required Haptics haptics,
    required Translations t,
    required ExportFormat format,
  }) async {
    try {
      ref.showLoading();
      await Future<void>.delayed(
        const Duration(milliseconds: 500),
      );
      
      final startDate = DateTime(
        selectedYear,
        selectedMonth,
      );
      final endDate = DateTime(
        selectedYear,
        selectedMonth + 1,
      ).subtract(const Duration(days: 1));
      
      final diaries = await dbClient.getDiaries(
        from: startDate,
        to: endDate,
      );
      
      final entries = diaries.map((Diary diary) {
        return DiaryEntry(
          date: diary.date,
          content: diary.content,
        );
      }).toList();
      
      final File exportedFile;
      final Icon successIcon;
      
      if (format == const ExportFormat.pdf()) {
        exportedFile = await pdfExporter.exportMonth(
          entries: entries,
          year: selectedYear,
          month: selectedMonth,
        );
        successIcon = const Icon(Icons.picture_as_pdf_outlined);
      } else if (format == const ExportFormat.csv()) {
        exportedFile = await csvExporter.exportMonth(
          entries: entries,
          year: selectedYear,
          month: selectedMonth,
        );
        successIcon = const Icon(Icons.table_chart_outlined);
      } else if (format == const ExportFormat.markdown()) {
        exportedFile = await markdownExporter.exportMonth(
          entries: entries,
          year: selectedYear,
          month: selectedMonth,
        );
        successIcon = const Icon(Icons.text_snippet_outlined);
      } else {
        throw UnimplementedError(
          '${format.displayName} export not yet implemented',
        );
      }

      if (!context.mounted) {
        return;
      }

      final shareXFile = XFile(exportedFile.path);
      await SharePlus.instance.share(
        ShareParams(files: [shareXFile]),
      );

      haptics.successFeedback();
      if (context.mounted) {
        showSuccessToast(
          context,
          title: t.export.successMessage,
          icon: successIcon,
        );
      }
    } on Object catch (e) {
      final tracker = ref.read(trackerProvider);
      unawaited(
        tracker.recordError(
          e,
          StackTrace.current,
          fatal: true,
        ),
      );
      if (context.mounted) {
        showErrorToast(
          context,
          title: t.export.failedMessage,
        );
      }
    } finally {
      ref.hideLoading();
    }
  }

  Widget _buildIOSYearPicker(
    BuildContext context,
    ValueNotifier<int> selectedYear,
    ValueNotifier<int> selectedMonth,
    ColorScheme colorScheme,
  ) {
    final currentYear = clock.now().year;
    final years = List.generate(20, (index) => currentYear - index);
    
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        unawaited(
          showCupertinoModalPopup<void>(
          context: context,
          builder: (context) => Container(
            height: 250,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: CupertinoPicker(
              backgroundColor:
                  CupertinoColors.systemBackground.resolveFrom(context),
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem: years.indexOf(selectedYear.value),
              ),
              onSelectedItemChanged: (index) {
                selectedYear.value = years[index];
                
                // 年が変更されたとき、選択されている月が無効な場合は調整
                final currentYear = clock.now().year;
                final currentMonth = clock.now().month;
                if (selectedYear.value == currentYear &&
                    selectedMonth.value > currentMonth) {
                  selectedMonth.value = currentMonth;
                }
              },
              children: years.map((year) => Center(
                child: Text(year.toString()),
              )).toList(),
            ),
          ),
        ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyMediumText(selectedYear.value.toString()),
            Icon(Icons.expand_more, color: colorScheme.onSurface),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidYearDropdown(
    BuildContext context,
    ValueNotifier<int> selectedYear,
    ValueNotifier<int> selectedMonth,
    ColorScheme colorScheme,
  ) {
    final currentYear = clock.now().year;
    final years = List.generate(20, (index) => currentYear - index);
    
    return DropdownButtonFormField<int>(
      value: selectedYear.value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      items: years.map((year) {
        return DropdownMenuItem(
          value: year,
          child: Text(year.toString()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          selectedYear.value = value;
          
          // 年が変更されたとき、選択されている月が無効な場合は調整
          final currentYear = clock.now().year;
          final currentMonth = clock.now().month;
          if (selectedYear.value == currentYear &&
              selectedMonth.value > currentMonth) {
            selectedMonth.value = currentMonth;
          }
        }
      },
    );
  }

  Widget _buildIOSMonthPicker(
    BuildContext context,
    ValueNotifier<int> selectedYear,
    ValueNotifier<int> selectedMonth,
    ColorScheme colorScheme,
  ) {
    final currentYear = clock.now().year;
    final currentMonth = clock.now().month;
    final maxMonth = selectedYear.value == currentYear ? currentMonth : 12;
    final months = List.generate(maxMonth, (index) => index + 1);
    
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        unawaited(
          showCupertinoModalPopup<void>(
          context: context,
          builder: (context) => Container(
            height: 250,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: CupertinoPicker(
              backgroundColor:
                  CupertinoColors.systemBackground.resolveFrom(context),
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem: months
                    .indexOf(selectedMonth.value)
                    .clamp(0, months.length - 1),
              ),
              onSelectedItemChanged: (index) {
                selectedMonth.value = months[index];
              },
              children: months.map((month) {
                final monthName = DateFormat.MMMM(
                  Localizations.localeOf(context).languageCode,
                ).format(DateTime(2024, month));
                return Center(
                  child: Text(monthName),
                );
              }).toList(),
            ),
          ),
        ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyMediumText(
              DateFormat.MMMM(Localizations.localeOf(context).languageCode)
                  .format(DateTime(2024, selectedMonth.value)),
            ),
            Icon(Icons.expand_more, color: colorScheme.onSurface),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidMonthDropdown(
    BuildContext context,
    ValueNotifier<int> selectedYear,
    ValueNotifier<int> selectedMonth,
    ColorScheme colorScheme,
  ) {
    final currentYear = clock.now().year;
    final currentMonth = clock.now().month;
    final maxMonth = selectedYear.value == currentYear ? currentMonth : 12;
    final months = List.generate(maxMonth, (index) => index + 1);
    
    // 選択されている月が利用可能な月より後の場合、最大月に調整
    if (selectedMonth.value > maxMonth) {
      selectedMonth.value = maxMonth;
    }
    
    return DropdownButtonFormField<int>(
      value: selectedMonth.value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      items: months.map((month) {
        final monthName = DateFormat.MMMM(
          Localizations.localeOf(context).languageCode,
        ).format(DateTime(2024, month));
        return DropdownMenuItem(
          value: month,
          child: Text(monthName),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          selectedMonth.value = value;
        }
      },
    );
  }

}
