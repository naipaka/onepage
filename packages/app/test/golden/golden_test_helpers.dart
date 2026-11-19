import 'dart:io';
import 'dart:ui' as ui;

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:i18n/i18n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';

import '../utils/clients.dart';

/// A theme and a language that a golden image is taken in.
enum GoldenVariant {
  lightEn(ThemeMode.light, Locale('en'), 'light_en'),
  darkEn(ThemeMode.dark, Locale('en'), 'dark_en'),
  lightJa(ThemeMode.light, Locale('ja'), 'light_ja');

  new(this.themeMode, this.locale, this.suffix);

  /// The theme of the image.
  final ThemeMode themeMode;

  /// The language of the image.
  final Locale locale;

  /// The end of the image's file name.
  final String suffix;
}

abstract final class GoldenTestHelpers {
  // On iOS, the engine draws these families with the system font, which tests
  // do not have. Noto Sans JP draws both the English and the Japanese text.
  static const _textFontFamilies = [
    'CupertinoSystemText',
    'CupertinoSystemDisplay',
  ];
  static const _textFontPath =
      'test/golden/fonts/NotoSansJP-VariableFont_wght.ttf';
  static const _iconFontFamily = 'MaterialIcons';
  static const _iconFontAsset = 'fonts/MaterialIcons-Regular.otf';

  static Future<void>? _fontsLoading;

  static Future<void> _loadFonts() async {
    final textFont = ByteData.sublistView(
      await File(_textFontPath).readAsBytes(),
    );
    for (final family in _textFontFamilies) {
      await (FontLoader(family)..addFont(Future.syncValue(textFont))).load();
    }
    await (FontLoader(
      _iconFontFamily,
    )..addFont(rootBundle.load(_iconFontAsset))).load();
  }

  /// Takes the golden image `goldens/<name>_<variant suffix>.png` of
  /// [widget], shown as the home of the app.
  ///
  /// The app runs on an iPhone 11 Pro screen at [now], which defaults to noon
  /// on 2025-01-15. [act] runs after the first frames settle and before the
  /// image is taken, to open a dialog or a sheet, and it pumps the frames it
  /// needs itself.
  static Future<void> expectGoldenMatches(
    WidgetTester tester,
    Widget widget,
    String name, {
    required GoldenVariant variant,
    DateTime? now,
    PrefsClient? prefsClient,
    DbClient? dbClient,
    PhotoStorage? photoStorage,
    List<Override> overrides = const [],
    Future<void> Function(WidgetTester tester)? act,
  }) async {
    await tester.runAsync(() => _fontsLoading ??= _loadFonts());
    await tester.runAsync(
      () => LocaleSettings.setLocaleRaw(variant.locale.languageCode),
    );

    // iPhone 11 Pro
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.view
      ..physicalSize = const Size(375, 812)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await withClock(Clock.fixed(now ?? DateTime(2025, 1, 15, 12)), () async {
      await tester.pumpWidget(
        ProviderScope(
          retry: noRetry,
          overrides: [
            prefsClientProvider.overrideWithValue(
              prefsClient ?? createPrefsClient(hapticsEnabled: true),
            ),
            dbClientProvider.overrideWithValue(dbClient ?? createDbClient()),
            photoStorageProvider.overrideWithValue(
              photoStorage ?? PhotoStorage(directory: Directory.systemTemp),
            ),
            inAppReviewerProvider.overrideWith(
              (ref) async => createInAppReviewer(),
            ),
            trackerProvider.overrideWithValue(createTracker()),
            notificationClientInitializingProvider.overrideWith(
              (ref) async => createNotificationClient(),
            ),
            packageInfoProvider.overrideWithValue(
              PackageInfo(
                appName: 'OnePage',
                packageName: 'jp.co.altive.onepage',
                version: '1.0.0',
                buildNumber: '1',
              ),
            ),
            ...overrides,
          ],
          child: TranslationProvider(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: appLightThemeData,
              darkTheme: appDarkThemeData,
              themeMode: variant.themeMode,
              localizationsDelegates: localizationsDelegates,
              supportedLocales: AppLocaleUtils.supportedLocales,
              locale: variant.locale,
              home: widget,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await loadImages(tester);

      if (act != null) {
        await act(tester);
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${name}_${variant.suffix}.png'),
      );
    });

    debugDefaultTargetPlatformOverride = null;
  }

  /// Waits until the images on the screen are loaded, and draws them.
  ///
  /// Images load from files and assets outside the fake time of the test,
  /// so the test lets real time pass between the frames.
  static Future<void> loadImages(WidgetTester tester) async {
    bool loaded() => tester
        .renderObjectList<RenderImage>(find.byType(RawImage))
        .every((image) => image.image != null);
    for (var i = 0; i < 100 && !loaded(); i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump();
    }
    expect(loaded(), isTrue, reason: 'The images on the screen did not load.');
  }

  /// Saves a picture of a sunset in [photoStorage] and returns its file name.
  ///
  /// Call it in [WidgetTester.runAsync].
  static Future<String> savePhoto(PhotoStorage photoStorage) async {
    const size = 256.0;
    final recorder = ui.PictureRecorder();
    Canvas(recorder)
      ..drawRect(
        const Rect.fromLTWH(0, 0, size, size),
        Paint()
          ..shader = ui.Gradient.linear(
            Offset.zero,
            const Offset(0, size),
            [const Color(0xFF3D5A98), const Color(0xFFF2A65A)],
          ),
      )
      ..drawCircle(
        const Offset(size * 0.65, size * 0.62),
        size * 0.14,
        Paint()..color = const Color(0xFFFFE29A),
      )
      ..drawRect(
        const Rect.fromLTWH(0, size * 0.7, size, size * 0.3),
        Paint()..color = const Color(0xFF2E4A3F),
      );
    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return photoStorage.save(bytes!.buffer.asUint8List());
  }
}
