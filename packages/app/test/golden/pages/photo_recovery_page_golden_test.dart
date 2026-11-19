@Tags(['golden'])
library;

import 'dart:async';

import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:i18n/i18n.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:onepage/pages/pages.dart';

import '../../utils/clients.dart';
import '../golden_fakes.dart';
import '../golden_test_helpers.dart';

/// Creates a database with two diary images whose photos are in the device's
/// photo library, and returns it with the ID of the first image.
Future<(DbClient, int)> _dbClientWithExternalImages(WidgetTester tester) async {
  final dbClient = createDbClient();
  final imageId = await tester.runAsync(() async {
    final images = [
      for (final (day, photoId) in [(10, 'a'), (12, 'b')])
        await insertExternalDiaryImage(
          dbClient,
          diaryId: (await dbClient.insertDiary(
            content: '',
            date: DateTime(2025, 1, day),
          )).id,
          photoId: photoId,
        ),
    ];
    return images.first.id;
  });
  return (dbClient, imageId!);
}

void main() {
  group('PhotoRecoveryPage Golden Tests', () {
    Future<void> expectGoldenMatches(
      WidgetTester tester,
      String name, {
      required GoldenVariant variant,
      bool withImageId = true,
      bool withImages = true,
      FakeDevicePhotos? devicePhotos,
      List<Override> overrides = const [],
      Future<void> Function(WidgetTester tester)? act,
    }) async {
      final (dbClient, imageId) = withImages
          ? await _dbClientWithExternalImages(tester)
          : (createDbClient(), null);
      await GoldenTestHelpers.expectGoldenMatches(
        tester,
        PhotoRecoveryPage(imageId: withImageId ? imageId : null),
        name,
        variant: variant,
        dbClient: dbClient,
        overrides: [
          devicePhotosProvider.overrideWithValue(
            devicePhotos ?? FakeDevicePhotos(),
          ),
          photoRecoveryCommandProvider.overrideWithValue(
            FakePhotoRecoveryCommand(running: true),
          ),
          ...overrides,
        ],
        act: act,
      );
    }

    for (final variant in GoldenVariant.values) {
      testWidgets('renders photos to recover with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'photo_recovery_page',
          variant: variant,
        );
      });

      testWidgets('renders photos missing on the device with '
          '${variant.suffix}', (tester) async {
        await expectGoldenMatches(
          tester,
          'photo_recovery_page_not_found',
          variant: variant,
          devicePhotos: FakeDevicePhotos(option: DevicePhotoAccessOption.none),
        );
      });

      testWidgets('renders a running recovery with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'photo_recovery_page_recovering',
          variant: variant,
          act: (tester) async {
            unawaited(
              ProviderScope.containerOf(
                tester.element(find.byType(PhotoRecoveryPage)),
              ).read(photoRecoveryProvider.notifier).recoverFromDevice(),
            );
            await tester.pumpAndSettle();
          },
        );
      });

      testWidgets('renders a completed recovery with ${variant.suffix}', (
        tester,
      ) async {
        await expectGoldenMatches(
          tester,
          'photo_recovery_page_done',
          variant: variant,
          withImageId: false,
          withImages: false,
        );
      });

      testWidgets('renders the request to allow access in the settings with '
          '${variant.suffix}', (tester) async {
        await expectGoldenMatches(
          tester,
          'photo_recovery_page_settings',
          variant: variant,
          devicePhotos: FakeDevicePhotos(
            option: DevicePhotoAccessOption.openSettings,
            request: DevicePhotoAccessRequest.unavailable,
          ),
          act: (tester) async {
            await tester.tap(find.text(t.photoRecovery.action));
            await tester.pumpAndSettle();
          },
        );
      });

      for (final (name, action) in [
        ('delete_unrecovered', () => t.photoRecovery.deleteUnrecovered.action),
        ('dismiss', () => t.photoRecovery.dismiss.action),
        ('delete_photo', () => t.photoRecovery.deletePhoto),
      ]) {
        testWidgets('renders the confirmation of $name with '
            '${variant.suffix}', (tester) async {
          await expectGoldenMatches(
            tester,
            'photo_recovery_page_$name',
            variant: variant,
            act: (tester) async {
              await tester.tap(find.text(action()));
              await tester.pumpAndSettle();
            },
          );
        });
      }
    }
  });
}
