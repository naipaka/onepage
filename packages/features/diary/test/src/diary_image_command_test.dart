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

  group('storePhoto', () {
    test('saves the encoded photo and returns its file name', () async {
      final encoded = Uint8List.fromList([1]);
      when(photoEncoder.encode('picked.jpg')).thenAnswer((_) async => encoded);
      when(photoStorage.save(encoded)).thenAnswer((_) async => 'photo.jpg');

      expect(await command.storePhoto('picked.jpg'), 'photo.jpg');
    });
  });

  group('addDiaryImage', () {
    final date = DateTime(2024);
    final entry = DiaryEntry(
      id: 2,
      content: 'Diary',
      date: date,
      createdAt: date,
      updatedAt: date,
    );
    final image = DiaryImage(
      id: 1,
      diaryId: 2,
      fileName: 'photo.jpg',
      createdAt: date,
      updatedAt: date,
    );

    setUp(() {
      when(
        dbClient.insertDiaryImage(diaryId: 2, fileName: 'photo.jpg'),
      ).thenAnswer((_) async => image);
    });

    test('adds the image to the diary entry of the date', () async {
      when(
        dbClient.getDiaryByDate(date: date),
      ).thenAnswer((_) async => entry);

      final result = await command.addDiaryImage(
        date: date,
        fileName: 'photo.jpg',
      );

      expect(result, (entry: entry, image: image));
      verifyNever(
        dbClient.insertDiary(content: anyNamed('content'), date: date),
      );
    });

    test('creates an empty diary entry when the date has none', () async {
      when(dbClient.getDiaryByDate(date: date)).thenAnswer((_) async => null);
      when(
        dbClient.insertDiary(content: '', date: date),
      ).thenAnswer((_) async => entry);

      final result = await command.addDiaryImage(
        date: date,
        fileName: 'photo.jpg',
      );

      expect(result, (entry: entry, image: image));
      verifyInOrder([
        dbClient.insertDiary(content: '', date: date),
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

  group('deleteExternalDiaryImages', () {
    test('deletes the images without touching photo files', () async {
      when(dbClient.deleteExternalDiaryImages()).thenAnswer((_) async {});

      await command.deleteExternalDiaryImages();

      verify(dbClient.deleteExternalDiaryImages()).called(1);
      verifyNever(photoStorage.delete(any));
    });
  });
}
