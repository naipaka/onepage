import 'package:clock/clock.dart';
import 'package:diary/diary.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgets/widgets.dart';

import 'common.dart';

void main() {
  patrol('creates a diary entry and marks its date on the calendar', ($) async {
    const content = 'My first diary entry';
    final date = clock.now();
    await createApp($);

    final diaryField = $(K.diaryCalendar).$(K.diaryTextField(date));
    await diaryField.waitUntilVisible();
    expect($.tester.widget<DiaryTextField>(diaryField).content, isNull);

    await diaryField.enterText(content);

    // The field's content property is updated from the saved diary entry.
    await $(
      find.byWidgetPredicate(
        (widget) =>
            widget is DiaryTextField &&
            widget.key == K.diaryTextField(date) &&
            widget.content == content,
        description: 'saved diary text for the selected date',
      ),
    ).waitUntilVisible();

    await $(K.diaryDatePickerButton).tap();
    final datePicker = $(CalendarDatePickerDialog);
    await datePicker.waitUntilVisible();
    expect(
      $.tester.widget<CalendarDatePickerDialog>(datePicker).markedDates,
      contains(
        predicate<DateTime>((markedDate) {
          return DateUtils.isSameDay(markedDate, date);
        }),
      ),
    );
  });
}
