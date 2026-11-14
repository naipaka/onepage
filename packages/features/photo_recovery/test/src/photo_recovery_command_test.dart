import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import 'package:photo_recovery/photo_recovery.dart';

import '../utils/mock.mocks.dart';

void main() {
  group('PhotoRecoveryCommand', () {
    late MockDbClient dbClient;
    late MockDevicePhotos devicePhotos;
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
      devicePhotos = MockDevicePhotos();
      photoEncoder = MockPhotoEncoder();
      photoStorage = MockPhotoStorage();
      command = PhotoRecoveryCommand(
        dbClient: dbClient,
        devicePhotos: devicePhotos,
        photoEncoder: photoEncoder,
        photoStorage: photoStorage,
      );
      directory = Directory.systemTemp.createTempSync('photo_recovery_test');
      addTearDown(() => directory.deleteSync(recursive: true));

      when(dbClient.getExternalDiaryImages()).thenAnswer(
        (_) async => [image(1, 'a'), image(2, 'b')],
      );
      when(
        devicePhotos.access,
      ).thenAnswer((_) async => DevicePhotoAccess.full);
      when(photoEncoder.encode(any)).thenAnswer((_) async => Uint8List(1));
      when(photoStorage.save(any)).thenAnswer((_) async => 'stored.jpg');
    });

    group('recoverFromDevice', () {
      test('does not ask for access without photos to recover', () async {
        when(dbClient.getExternalDiaryImages()).thenAnswer((_) async => []);

        expect(await command.recoverFromDevice(), 0);
        verifyNever(devicePhotos.access);
      });

      test('reads nothing without access', () async {
        when(
          devicePhotos.access,
        ).thenAnswer((_) async => DevicePhotoAccess.denied);

        expect(await command.recoverFromDevice(), 0);
        verifyNever(devicePhotos.read(any));
      });

      test('never asks the user for access', () async {
        when(devicePhotos.read(any)).thenAnswer((_) async => null);

        await command.recoverFromDevice();

        verifyNever(devicePhotos.requestAccess());
      });

      test('stores the photos the library can read', () async {
        when(devicePhotos.read('a')).thenAnswer((_) async => File('a.jpg'));
        when(devicePhotos.read('b')).thenAnswer((_) async => null);

        final recovered = await command.recoverFromDevice();

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
        when(devicePhotos.read(any)).thenAnswer((_) async => File('a.jpg'));
        when(photoEncoder.encode(any)).thenAnswer((_) async {
          throw Exception('failed');
        });

        expect(await command.recoverFromDevice(), 0);
        verify(devicePhotos.read('a')).called(1);
        verify(devicePhotos.read('b')).called(1);
      });

      test('recovers up to six photos at a time', () async {
        when(dbClient.getExternalDiaryImages()).thenAnswer(
          (_) async => [for (var i = 1; i <= 8; i++) image(i, '$i')],
        );
        final reads = <String, Completer<File?>>{};
        when(devicePhotos.read(any)).thenAnswer((invocation) {
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
        when(devicePhotos.read(any)).thenAnswer((_) async => null);
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
          devicePhotos.requestPhotos(any),
        ).thenAnswer((_) async => documents);
      }

      setUp(() {
        copy = File(p.join(directory.path, 'copy'))..writeAsBytesSync([1]);
        when(
          devicePhotos.copyDocument('document'),
        ).thenAnswer((_) async => copy);
      });

      test('does not ask without photos to recover', () async {
        when(dbClient.getExternalDiaryImages()).thenAnswer((_) async => []);

        expect(await command.recoverRequested(), 0);
        verifyNever(devicePhotos.requestPhotos(any));
      });

      test('asks for the photos to recover', () async {
        allow({});

        await command.recoverRequested();

        verify(devicePhotos.requestPhotos(['a', 'b'])).called(1);
      });

      test('returns null when the user declines', () async {
        allow(null);
        final progress = <(int, int)>[];

        final recovered = await command.recoverRequested(
          onProgress: (completed, total) => progress.add((completed, total)),
        );

        expect(recovered, isNull);
        expect(progress, isEmpty);
        verifyNever(devicePhotos.copyDocument(any));
      });

      test('stores the allowed photos', () async {
        allow({'b': 'document'});

        final recovered = await command.recoverRequested();

        expect(recovered, 1);
        verify(
          dbClient.setDiaryImageFileName(id: 2, fileName: 'stored.jpg'),
        ).called(1);
      });

      test('deletes the temporary copy', () async {
        allow({'a': 'document'});

        await command.recoverRequested();

        expect(copy.existsSync(), isFalse);
      });

      test('deletes the temporary copy when storing fails', () async {
        allow({'a': 'document'});
        when(photoEncoder.encode(any)).thenAnswer((_) async {
          throw Exception('failed');
        });

        expect(await command.recoverRequested(), 0);
        expect(copy.existsSync(), isFalse);
      });
    });
  });
}
