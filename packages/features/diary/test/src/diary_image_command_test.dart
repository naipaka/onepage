import 'dart:typed_data';

import 'package:db_client/db_client.dart';
import 'package:diary/src/diary_image_command.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../utils/mock.mocks.dart';

void main() {
  late MockDbClient dbClient;
  late MockPhotoEncoder photoEncoder;
  late MockPhotoStorage photoStorage;
  late DiaryImageCommand command;

  setUp(() {
    dbClient = MockDbClient();
    photoEncoder = MockPhotoEncoder();
    photoStorage = MockPhotoStorage();
    command = DiaryImageCommand(
      dbClient: dbClient,
      photoEncoder: photoEncoder,
      photoStorage: photoStorage,
    );
  });

  group('addDiaryImage', () {
    test('stores the encoded photo and then adds the row', () async {
      final bytes = Uint8List.fromList([1]);
      final encoded = Uint8List.fromList([2]);
      final image = DiaryImage(
        id: 1,
        diaryId: 2,
        fileName: 'photo.jpg',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      when(photoEncoder.encode(bytes)).thenAnswer((_) async => encoded);
      when(photoStorage.save(encoded)).thenAnswer((_) async => 'photo.jpg');
      when(
        dbClient.insertDiaryImage(diaryId: 2, fileName: 'photo.jpg'),
      ).thenAnswer((_) async => image);

      final result = await command.addDiaryImage(diaryId: 2, bytes: bytes);

      expect(result, image);
      verifyInOrder([
        photoEncoder.encode(bytes),
        photoStorage.save(encoded),
        dbClient.insertDiaryImage(diaryId: 2, fileName: 'photo.jpg'),
      ]);
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
