import 'package:clock/clock.dart';
import 'package:exporter/exporter.dart';
import 'package:exporter/src/export_period.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(initializeDateFormatting);

  group('ExportPeriod', () {
    group('ofEntries', () {
      test('is the current month when there are no entries', () {
        withClock(Clock.fixed(DateTime(2026, 11, 17)), () {
          final period = ExportPeriod.ofEntries([]);

          expect(period.title('en'), 'November 2026');
          expect(period.title('ja'), '2026年11月');
          expect(period.fileNamePart, '2026-11');
        });
      });

      test('is one month when the entries are in the same month', () {
        final period = ExportPeriod.ofEntries([
          ExportDiary(date: DateTime(2026, 11, 17), content: 'b'),
          ExportDiary(date: DateTime(2026, 11, 3), content: 'a'),
        ]);

        expect(period.title('en'), 'November 2026');
        expect(period.title('ja'), '2026年11月');
        expect(period.fileNamePart, '2026-11');
      });

      test('is the first to the last month of the entries', () {
        final period = ExportPeriod.ofEntries([
          ExportDiary(date: DateTime(2026, 11, 17), content: 'b'),
          ExportDiary(date: DateTime(2026, 1, 3), content: 'a'),
        ]);

        expect(period.title('en'), 'January 2026 - November 2026');
        expect(period.title('ja'), '2026年1月 - 2026年11月');
        expect(period.fileNamePart, '2026-01_2026-11');
      });
    });

    test('month is the given month', () {
      final period = ExportPeriod.month(2026, 11);

      expect(period.title('en'), 'November 2026');
      expect(period.title('ja'), '2026年11月');
      expect(period.fileNamePart, '2026-11');
    });

    group('dateRange', () {
      test('is one day when the start and the end are the same day', () {
        final period = ExportPeriod.dateRange(
          DateTime(2026, 11, 17),
          DateTime(2026, 11, 17),
        );

        expect(period.title('en'), 'Tue, Nov 17, 2026');
        expect(period.title('ja'), '2026年11月17日(火)');
        expect(period.fileNamePart, '2026-11-17');
      });

      test('is the month when the start and the end are in one month', () {
        final period = ExportPeriod.dateRange(
          DateTime(2026, 11, 2),
          DateTime(2026, 11, 17),
        );

        expect(period.title('en'), 'November 2026');
        expect(period.title('ja'), '2026年11月');
        expect(period.fileNamePart, '2026-11');
      });

      test('is the days from the start to the end across months', () {
        final period = ExportPeriod.dateRange(
          DateTime(2026, 11),
          DateTime(2026, 12, 3),
        );

        expect(period.title('en'), 'Nov 1, 2026 - Dec 3, 2026');
        expect(period.title('ja'), '2026年11月1日 - 2026年12月3日');
        expect(period.fileNamePart, '2026-11-01_2026-12-03');
      });
    });
  });
}
