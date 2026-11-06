import 'dart:io';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;

import '../utils/mock.mocks.dart';

void main() {
  group('PhotoRecoveryCommand', () {
    late MockDbClient dbClient;
    late MockPhotoLibrary photoLibrary;
    late MockPhotoEncoder photoEncoder;
    late MockPhotoStorage photoStorage;
    late PhotoRecoveryCommand command;
    late Directory directory;

    DiaryImage image(int id, String photoId) {
      final now = clock.now();
      return DiaryImage(
        id: id,
        diaryId: 1,
        photoId: photoId,
        createdAt: now,
        updatedAt: now,
      );
    }

    setUp(() {
      dbClient = MockDbClient();
      photoLibrary = MockPhotoLibrary();
      photoEncoder = MockPhotoEncoder();
      photoStorage = MockPhotoStorage();
      command = PhotoRecoveryCommand(
        dbClient: dbClient,
        photoLibrary: photoLibrary,
        photoEncoder: photoEncoder,
        photoStorage: photoStorage,
      );
      directory = Directory.systemTemp.createTempSync('photo_recovery_test');
      addTearDown(() => directory.deleteSync(recursive: true));

      when(dbClient.getUnmigratedDiaryImages()).thenAnswer(
        (_) async => [image(1, 'a'), image(2, 'b')],
      );
      when(photoEncoder.encode(any)).thenAnswer((_) async => Uint8List(1));
      when(photoStorage.save(any)).thenAnswer((_) async => 'stored.jpg');
    });

    group('recoverFromLibrary', () {
      test('stores the photos the library can read', () async {
        when(photoLibrary.read('a')).thenAnswer((_) async => File('a.jpg'));
        when(photoLibrary.read('b')).thenAnswer((_) async => null);

        final recovered = await command.recoverFromLibrary();

        expect(recovered, 1);
        verify(
          dbClient.setDiaryImageFileName(id: 1, fileName: 'stored.jpg'),
        ).called(1);
        verifyNever(
          dbClient.setDiaryImageFileName(
            id: 2,
            fileName: anyNamed('fileName'),
          ),
        );
      });

      test('continues after a photo fails', () async {
        when(photoLibrary.read(any)).thenAnswer((_) async => File('a.jpg'));
        when(photoEncoder.encode(any)).thenAnswer((_) async {
          throw Exception('failed');
        });

        expect(await command.recoverFromLibrary(), 0);
        verify(photoLibrary.read('a')).called(1);
        verify(photoLibrary.read('b')).called(1);
      });

      test('reports progress for each photo', () async {
        when(photoLibrary.read(any)).thenAnswer((_) async => null);
        final progress = <(int, int)>[];

        await command.recoverFromLibrary(
          onProgress: (completed, total) => progress.add((completed, total)),
        );

        expect(progress, [(1, 2), (2, 2)]);
      });
    });

    group('recoverFromFolder', () {
      late File copy;

      setUp(() {
        copy = File(p.join(directory.path, 'copy'))..writeAsBytesSync([1]);
        when(
          photoLibrary.findInFolder(folder: 'folder', ids: ['a', 'b']),
        ).thenAnswer((_) async => {'a': 'document'});
        when(
          photoLibrary.copyDocument('document'),
        ).thenAnswer((_) async => copy);
      });

      test('stores the photos found in the folder', () async {
        final recovered = await command.recoverFromFolder('folder');

        expect(recovered, 1);
        verify(
          dbClient.setDiaryImageFileName(id: 1, fileName: 'stored.jpg'),
        ).called(1);
      });

      test('deletes the temporary copy', () async {
        await command.recoverFromFolder('folder');

        expect(copy.existsSync(), isFalse);
      });

      test('deletes the temporary copy when storing fails', () async {
        when(photoEncoder.encode(any)).thenAnswer((_) async {
          throw Exception('failed');
        });

        expect(await command.recoverFromFolder('folder'), 0);
        expect(copy.existsSync(), isFalse);
      });
    });
  });
}
