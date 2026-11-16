import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';

import '../utils/mock.dart';

void main() {
  group('PhotoRecoveryCommand', () {
    late DbClient dbClient;
    late MockDevicePhotos devicePhotos;
    late MockPhotoEncoder photoEncoder;
    late PhotoStorage photoStorage;
    late PhotoRecoveryCommand command;
    late Directory directory;
    late DiaryEntry diary;

    Future<void> addExternalImages(List<String> photoIds) async {
      for (final photoId in photoIds) {
        await insertExternalDiaryImage(
          dbClient,
          diaryId: diary.id,
          photoId: photoId,
        );
      }
    }

    Future<List<String?>> externalPhotoIds() async => [
      for (final image in await dbClient.getExternalDiaryImages())
        image.photoId,
    ];

    setUp(() async {
      dbClient = createInMemoryDbClient();
      addTearDown(dbClient.close);
      devicePhotos = MockDevicePhotos();
      photoEncoder = MockPhotoEncoder();
      directory = Directory.systemTemp.createTempSync('photo_recovery_test');
      addTearDown(() => directory.deleteSync(recursive: true));
      photoStorage = PhotoStorage(
        directory: Directory(p.join(directory.path, 'photos')),
      );
      command = PhotoRecoveryCommand(
        dbClient: dbClient,
        devicePhotos: devicePhotos,
        photoEncoder: photoEncoder,
        photoStorage: photoStorage,
      );

      diary = await dbClient.insertDiary(content: '', date: DateTime(2024));
      await addExternalImages(['a', 'b']);
      when(
        () => devicePhotos.access,
      ).thenAnswer((_) async => DevicePhotoAccess.full);
      when(
        () => photoEncoder.encode(any()),
      ).thenAnswer((_) async => Uint8List.fromList([1]));
    });

    group('recoverFromDevice', () {
      test('does not ask for access without photos to recover', () async {
        await dbClient.deleteExternalDiaryImages();

        expect(await command.recoverFromDevice(), 0);
        verifyNever(() => devicePhotos.access);
      });

      test('reads nothing without access', () async {
        when(
          () => devicePhotos.access,
        ).thenAnswer((_) async => DevicePhotoAccess.denied);

        expect(await command.recoverFromDevice(), 0);
        verifyNever(() => devicePhotos.read(any()));
      });

      test('never asks the user for access', () async {
        when(() => devicePhotos.read(any())).thenAnswer((_) async => null);

        await command.recoverFromDevice();

        verifyNever(() => devicePhotos.requestAccess());
      });

      test('stores the photos the library can read', () async {
        when(() => devicePhotos.read('a'))
            .thenAnswer((_) async => File('a.jpg'));
        when(() => devicePhotos.read('b')).thenAnswer((_) async => null);

        final recovered = await command.recoverFromDevice();

        expect(recovered, 1);
        expect(await externalPhotoIds(), ['b']);
        final fileNames = await dbClient.getDiaryImageFileNames();
        expect(fileNames, hasLength(1));
        expect(photoStorage.file(fileNames.single).readAsBytesSync(), [1]);
      });

      test('continues after a photo fails', () async {
        when(() => devicePhotos.read(any()))
            .thenAnswer((_) async => File('a.jpg'));
        when(() => photoEncoder.encode(any())).thenAnswer((_) async {
          throw Exception('failed');
        });

        expect(await command.recoverFromDevice(), 0);
        verify(() => devicePhotos.read('a')).called(1);
        verify(() => devicePhotos.read('b')).called(1);
        expect(await externalPhotoIds(), ['a', 'b']);
      });

      test('recovers up to six photos at a time', () async {
        await dbClient.deleteExternalDiaryImages();
        await addExternalImages([for (var i = 1; i <= 8; i++) '$i']);
        final reads = <String, Completer<File?>>{};
        when(() => devicePhotos.read(any())).thenAnswer((invocation) {
          final id = invocation.positionalArguments.first as String;
          return (reads[id] = Completer<File?>()).future;
        });

        final recovery = command.recoverFromDevice();
        await pumpEventQueue();
        expect(reads.keys, ['1', '2', '3', '4', '5', '6']);

        reads['2']!.complete(null);
        await pumpEventQueue();
        expect(reads.keys, ['1', '2', '3', '4', '5', '6', '7']);

        for (final read in reads.values.where((read) => !read.isCompleted)) {
          read.complete(null);
        }
        await pumpEventQueue();
        reads['8']!.complete(null);
        expect(await recovery, 0);
      });

      test('reports the start and each photo', () async {
        when(() => devicePhotos.read(any())).thenAnswer((_) async => null);
        final progress = <(int, int)>[];

        await command.recoverFromDevice(
          onProgress: (completed, total) => progress.add((completed, total)),
        );

        expect(progress, [(0, 2), (1, 2), (2, 2)]);
      });
    });

    group('recoverRequested', () {
      late File copy;

      void allow(Map<String, String>? documents) {
        when(
          () => devicePhotos.requestPhotos(any()),
        ).thenAnswer((_) async => documents);
      }

      setUp(() {
        copy = File(p.join(directory.path, 'copy'))..writeAsBytesSync([1]);
        when(
          () => devicePhotos.copyDocument('document'),
        ).thenAnswer((_) async => copy);
      });

      test('does not ask without photos to recover', () async {
        await dbClient.deleteExternalDiaryImages();

        expect(await command.recoverRequested(), 0);
        verifyNever(() => devicePhotos.requestPhotos(any()));
      });

      test('asks for the photos to recover', () async {
        allow({});

        await command.recoverRequested();

        verify(() => devicePhotos.requestPhotos(['a', 'b'])).called(1);
      });

      test('returns null when the user declines', () async {
        allow(null);
        final progress = <(int, int)>[];

        final recovered = await command.recoverRequested(
          onProgress: (completed, total) => progress.add((completed, total)),
        );

        expect(recovered, isNull);
        expect(progress, isEmpty);
        verifyNever(() => devicePhotos.copyDocument(any()));
      });

      test('stores the allowed photos', () async {
        allow({'b': 'document'});

        final recovered = await command.recoverRequested();

        expect(recovered, 1);
        expect(await externalPhotoIds(), ['a']);
        final fileNames = await dbClient.getDiaryImageFileNames();
        expect(photoStorage.file(fileNames.single).readAsBytesSync(), [1]);
      });

      test('deletes the temporary copy', () async {
        allow({'a': 'document'});

        await command.recoverRequested();

        expect(copy.existsSync(), isFalse);
      });

      test('deletes the temporary copy when storing fails', () async {
        allow({'a': 'document'});
        when(() => photoEncoder.encode(any())).thenAnswer((_) async {
          throw Exception('failed');
        });

        expect(await command.recoverRequested(), 0);
        expect(copy.existsSync(), isFalse);
      });
    });
  });
}
