import 'package:db_client/db_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:provider_utils/provider_utils.dart';

import '../../utils/clients.dart';

void main() {
  late DbClient dbClient;
  late ProviderContainer container;

  setUp(() async {
    dbClient = createDbClient();
    for (var i = 0; i < 45; i++) {
      await dbClient.insertDiary(
        content: 'cafe $i',
        date: DateTime(2026, 10, 1 + i),
      );
    }
    container = ProviderContainer(
      retry: noRetry,
      overrides: [dbClientProvider.overrideWithValue(dbClient)],
    );
    addTearDown(container.dispose);
  });

  group('DiarySearch', () {
    DiarySearch notifier() => container.read(diarySearchProvider.notifier);

    List<String> contents() => [
      for (final diary in container.read(diarySearchProvider).diaries)
        diary.content,
    ];

    test('loadMore adds the next pages until none are left', () async {
      await notifier().search('cafe');

      await notifier().loadMore();
      await notifier().loadMore();

      expect(contents(), [for (var i = 44; i >= 0; i--) 'cafe $i']);
      expect(container.read(diarySearchProvider).hasMore, isFalse);
    });

    test('calls during a load wait for it instead of loading again', () async {
      await notifier().search('cafe');

      await Future.wait([notifier().loadMore(), notifier().loadMore()]);

      expect(contents(), [for (var i = 44; i >= 5; i--) 'cafe $i']);
    });
  });
}
