import 'dart:io';
import 'dart:typed_data';

import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:diary/src/diary_image_command.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:test/test.dart';

import '../utils/mock.dart';

void main() {
  late DbClient dbClient;
  late MockPhotoEncoder photoEncoder;
  late PhotoStorage photoStorage;
  late DiaryImageCommand command;
  final date = DateTime(2024);

  setUp(() {
    dbClient = createInMemoryDbClient();
    addTearDown(dbClient.close);
    photoEncoder = MockPhotoEncoder();
    final directory = Directory.systemTemp.createTempSync('diary_image_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    photoStorage = PhotoStorage(directory: directory);
    command = DiaryImageCommand(
      dbClient: dbClient,
      photoEncoder: photoEncoder,
      photoStorage: photoStorage,
    );
  });

  group('storePhoto', () {
    test('saves the encoded photo and returns its file name', () async {
      when(
        () => photoEncoder.encode('picked.jpg'),
      ).thenAnswer((_) async => Uint8List.fromList([1, 2]));

      final fileName = await command.storePhoto('picked.jpg');

      expect(photoStorage.file(fileName).readAsBytesSync(), [1, 2]);
    });
  });

  group('addDiaryImage', () {
    test('adds the image to the diary entry of the date', () async {
      final entry = await dbClient.insertDiary(content: 'Diary', date: date);

      final result = await command.addDiaryImage(
        date: date,
        fileName: 'photo.jpg',
      );

      expect(result.entry, entry);
      expect(result.image.diaryId, entry.id);
      expect(result.image.fileName, 'photo.jpg');
      expect(await dbClient.getDiaries(from: date, to: date), [
        Diary(entry: entry, images: [result.image]),
      ]);
    });

    test('creates an empty diary entry when the date has none', () async {
      final result = await command.addDiaryImage(
        date: date,
        fileName: 'photo.jpg',
      );

      expect(result.entry.content, '');
      expect(result.entry.date, date);
      expect(await dbClient.getDiaries(from: date, to: date), [
        Diary(entry: result.entry, images: [result.image]),
      ]);
    });
  });

  group('deleteDiaryImage', () {
    test('deletes the row and its file', () async {
      final entry = await dbClient.insertDiary(content: 'Diary', date: date);
      final fileName = await photoStorage.save(Uint8List.fromList([1]));
      final image = await dbClient.insertDiaryImage(
        diaryId: entry.id,
        fileName: fileName,
      );

      await command.deleteDiaryImage(id: image.id);

      expect(await dbClient.getDiaryImageFileNames(), isEmpty);
      expect(photoStorage.file(fileName).existsSync(), isFalse);
    });

    test('keeps the photo files when the image has no file', () async {
      final entry = await dbClient.insertDiary(content: 'Diary', date: date);
      final fileName = await photoStorage.save(Uint8List.fromList([1]));
      final image = await insertExternalDiaryImage(
        dbClient,
        diaryId: entry.id,
        photoId: 'photo',
      );

      await command.deleteDiaryImage(id: image.id);

      expect(await dbClient.getExternalDiaryImages(), isEmpty);
      expect(photoStorage.file(fileName).existsSync(), isTrue);
    });
  });

  group('deleteExternalDiaryImages', () {
    test('deletes the images without touching photo files', () async {
      final entry = await dbClient.insertDiary(content: 'Diary', date: date);
      final fileName = await photoStorage.save(Uint8List.fromList([1]));
      await dbClient.insertDiaryImage(diaryId: entry.id, fileName: fileName);
      await insertExternalDiaryImage(
        dbClient,
        diaryId: entry.id,
        photoId: 'photo',
      );

      await command.deleteExternalDiaryImages();

      expect(await dbClient.getExternalDiaryImages(), isEmpty);
      expect(await dbClient.getDiaryImageFileNames(), {fileName});
      expect(photoStorage.file(fileName).existsSync(), isTrue);
    });
  });
}
