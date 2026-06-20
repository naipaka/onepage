import 'common.dart';

void main() {
  patrol('shows the diary calendar after launch', ($) async {
    await createApp($);

    expect($(K.diaryCalendar), findsOneWidget);
  });
}
