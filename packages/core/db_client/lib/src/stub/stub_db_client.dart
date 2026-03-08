// For testing purposes, we use a stub database client that returns dummy data.
// ignore_for_file: avoid_hardcoded_japanese
import 'dart:async';

import 'package:clock/clock.dart';

import '../../db_client.dart';

/// {@template db_client.StubDbClient}
/// A stub database client for testing purposes.
/// {@endtemplate}
class StubDbClient extends DbClient {
  /// {@macro db_client.StubDbClient}
  StubDbClient({required this.locale}) : super();

  /// The locale of the device.
  final String locale;

  @override
  Future<DiaryEntry> insertDiary({
    required String content,
    required DateTime date,
  }) async {
    final now = clock.now();
    return DiaryEntry(
      id: 1,
      content: content,
      date: date,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<List<Diary>> getDiaries({
    required DateTime from,
    required DateTime to,
  }) async {
    final now = clock.now();
    if (locale == 'ja') {
      final entries = List.generate(
        4,
        (index) => DiaryEntry(
          id: index + 1,
          content: _stubJapaneseContents[index],
          date: now.subtract(Duration(days: index)),
          createdAt: now,
          updatedAt: now,
        ),
      );
      return entries.map((entry) => Diary(entry: entry)).toList();
    }

    final entries = List.generate(
      4,
      (index) => DiaryEntry(
        id: index + 1,
        content: _stubEnglishContents[index],
        date: now.subtract(Duration(days: index)),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return entries.map((entry) => Diary(entry: entry)).toList();
  }

  @override
  Future<int> updateDiary({required int id, required String content}) async {
    return 1;
  }
}

final List<String> _stubJapaneseContents = [
  '''春は、あけぼの。やうやう白くなりゆく、山ぎは少し明かりて、紫だちたる雲の細くたなびきたる。''',
  '''夏は、夜。月のころはさらなり、闇もなほ、蛍の多く飛びちがひたる。また、ただ一つ二つなど、ほのかにうち光りて行くも、をかし。雨など降るも、をかし。''',
  '''秋は、夕暮れ。夕日のさして山の端いと近うなりたるに、烏の寝どころへ行くとて、三つ四つ、二つ三つなど、飛び急ぐさへ、あはれなり。まいて雁などの連ねたるが、いと小さく見ゆるは、いとをかし。日入り果てて、風の音、虫の音など、はた言ふべきにあらず。''',
  '''冬は、つとめて。雪の降りたるは、言ふべきにもあらず、霜のいと白きも、また、さらでもいと寒きに、火など急ぎおこして、炭持て渡るも、いとつきづきし。昼になりて、ぬるくゆるびもていけば、火桶の火も白き灰がちになりて、わろし。''',
].reversed.toList();

final List<String> _stubEnglishContents = [
  '''Woke up early today and hit the gym before work. Feeling energized and ready to tackle the week! Had a great meeting with the team about our new project. Grabbed coffee with Sarah afterwards and discussed some exciting ideas. Ended the night watching the latest episode of "Ted Lasso" - always makes me laugh.''',
  '''Rainy day in the city. Worked from home and used the time to catch up on some reading. Started a new book recommended by my book club - "The Midnight Library" by Matt Haig. Ordered Thai food for dinner and had a video call with my parents. They're planning a trip to visit me next month, which I'm really looking forward to.''',
  '''Midweek blues hit hard today. Pushed through a challenging work presentation and felt relieved when it was over. Treated myself to a nice walk in the park after work. The autumn leaves are looking beautiful. Cooked a new recipe - chicken parmesan - turned out pretty good! Feeling proud of my cooking skills.''',
  '''Spontaneous day! Got surprise tickets to a local indie band's concert from a friend. The music was incredible, and the venue had such a cool vibe. Met some interesting people and ended up grabbing late-night tacos. Sometimes the best memories are unplanned. Feeling grateful for unexpected adventures.''',
].reversed.toList();
