import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// {@template calendar_date_picker_dialog}
/// A calendar dialog widget for date selection.
///
/// Displays a monthly calendar view where users can select dates.
/// Special dates can be marked with dot indicators.
/// {@endtemplate}
class CalendarDatePickerDialog extends StatefulWidget {
  /// {@macro calendar_date_picker_dialog}
  const CalendarDatePickerDialog({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.markedDates,
    this.onMonthChanged,
    required this.cancelLabel,
    required this.confirmLabel,
  });

  /// Initial selected date
  final DateTime initialDate;

  /// First selectable date (null for unlimited past)
  final DateTime? firstDate;

  /// Last selectable date (null for unlimited future)
  final DateTime? lastDate;

  /// Dates that should be marked with indicators
  final Set<DateTime> markedDates;

  /// Callback when user navigates to a different month
  /// (returns the 1st day of the month)
  final void Function(DateTime month)? onMonthChanged;

  /// Label for cancel button
  final String cancelLabel;

  /// Label for confirm button
  final String confirmLabel;

  @override
  State<CalendarDatePickerDialog> createState() =>
      _CalendarDatePickerDialogState();
}

class _CalendarDatePickerDialogState extends State<CalendarDatePickerDialog> {
  late DateTime _displayDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _displayDate = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(CalendarDatePickerDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update state when widget properties change
    if (widget.firstDate != oldWidget.firstDate ||
        widget.lastDate != oldWidget.lastDate ||
        widget.markedDates != oldWidget.markedDates) {
      setState(() {
        // Trigger rebuild with new properties
      });
    }
  }

  /// Navigate to previous month
  void _previousMonth() {
    setState(() {
      _displayDate = DateTime(_displayDate.year, _displayDate.month - 1);
    });
    // Call onMonthChanged callback with the 1st day of the new month
    widget.onMonthChanged?.call(
      DateTime(_displayDate.year, _displayDate.month),
    );
  }

  /// Navigate to next month
  void _nextMonth() {
    setState(() {
      _displayDate = DateTime(_displayDate.year, _displayDate.month + 1);
    });
    // Call onMonthChanged callback with the 1st day of the new month
    widget.onMonthChanged?.call(
      DateTime(_displayDate.year, _displayDate.month),
    );
  }

  /// Select a date
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  /// Get weekday labels using intl
  List<String> _getWeekdayLabels(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.E(locale.toString());

    // Generate weekday labels starting from Sunday
    final sunday = DateTime(2023); // Known Sunday
    return List.generate(7, (index) {
      final date = sunday.add(Duration(days: index));
      return dateFormat.format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.sizeOf(context);

    // Calculate responsive width with maximum constraint
    final maxWidth = screenSize.width * 0.9;
    final dialogWidth = maxWidth > 400 ? 400.0 : maxWidth;
    return AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                DateFormat.yMMMM(
                  Localizations.localeOf(context).toString(),
                ).format(_displayDate),
                style: theme.textTheme.titleLarge,
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Weekday header
          Row(
            children: _getWeekdayLabels(context)
                .map(
                  (day) => Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: _CalendarGrid(
          displayDate: _displayDate,
          selectedDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          markedDates: widget.markedDates,
          onDateSelected: _selectDate,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selectedDate),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// Calendar grid widget for displaying calendar dates
class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.displayDate,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.markedDates,
    required this.onDateSelected,
  });

  final DateTime displayDate;
  final DateTime selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Set<DateTime> markedDates;
  final ValueChanged<DateTime> onDateSelected;

  /// Get number of days in month
  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// Get weekday of first day of month (0=Sunday)
  int _getFirstDayOfWeek(DateTime date) {
    return DateTime(date.year, date.month).weekday % 7;
  }

  /// Check if date is selectable
  bool _isDateSelectable(DateTime date) {
    if (firstDate != null && date.isBefore(firstDate!)) {
      return false;
    }
    if (lastDate != null && date.isAfter(lastDate!)) {
      return false;
    }
    return true;
  }

  /// Check if date is marked
  bool _isMarked(DateTime date) {
    if (markedDates.isEmpty) {
      return false;
    }
    return markedDates.any(
      (markedDate) => DateUtils.isSameDay(markedDate, date),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final daysInMonth = _getDaysInMonth(displayDate);
    final firstDayOfWeek = _getFirstDayOfWeek(displayDate);

    // Calculate required rows dynamically
    final totalDays = daysInMonth + firstDayOfWeek;
    final requiredRows = (totalDays / 7).ceil();
    final totalCells = requiredRows * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - firstDayOfWeek + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(displayDate.year, displayDate.month, dayNumber);
        final isSelectable = _isDateSelectable(date);
        final isSelected = DateUtils.isSameDay(date, selectedDate);
        final isMarked = _isMarked(date);
        final isToday = DateUtils.isSameDay(date, clock.now());

        return InkWell(
          onTap: isSelectable ? () => onDateSelected(date) : null,
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : isToday && !isSelected
                  ? colorScheme.surfaceContainer
                  : null,
              borderRadius: BorderRadius.circular(16),
              border: isToday && !isSelected
                  ? Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                    )
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  dayNumber.toString(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: !isSelectable
                        ? colorScheme.onSurface.withValues(alpha: 0.38)
                        : isSelected
                        ? colorScheme.onPrimary
                        : isToday
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (isMarked)
                  Positioned(
                    bottom: 2,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : isToday
                            ? colorScheme.primary
                            : colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
