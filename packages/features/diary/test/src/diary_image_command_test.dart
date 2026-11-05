import 'package:db_client/db_client.dart';
import 'package:diary/src/diary_image_command.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../utils/mock.mocks.dart';

void main() {
  late MockDbClient dbClient;
  late MockPhotoStorage photoStorage;
  late DiaryImageCommand command;

  setUp(() {
    dbClient = MockDbClient();
    photoStorage = MockPhotoStorage();
    command = DiaryImageCommand(dbClient: dbClient, photoStorage: photoStorage);
  });

  group('addDiaryImage', () {
    test('inserts a diary image', () async {
      final image = DiaryImage(
        id: 1,
        diaryId: 2,
        photoId: 'photo-id',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      when(
        dbClient.insertDiaryImage(diaryId: 2, photoId: 'photo-id'),
      ).thenAnswer((_) async => image);

      final result = await command.addDiaryImage(
        diaryId: 2,
        photoId: 'photo-id',
      );

      expect(result, image);
    });
  });

  group('deleteDiaryImage', () {
    test('deletes the row and then its file', () async {
      when(
        dbClient.deleteDiaryImage(id: 1),
      ).thenAnswer((_) async => 'photo.jpg');

      await command.deleteDiaryImage(id: 1);

      verifyInOrder([
        dbClient.deleteDiaryImage(id: 1),
        photoStorage.delete('photo.jpg'),
      ]);
    });

    test('does not delete a file when the image has none', () async {
      when(dbClient.deleteDiaryImage(id: 1)).thenAnswer((_) async => null);

      await command.deleteDiaryImage(id: 1);

      verifyNever(photoStorage.delete(any));
    });
  });
}
