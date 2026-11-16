/// {@template app.AppAsset}
/// The asset files of the app.
///
/// one_page_lints checks that the values match the files listed under
/// `assets` in `pubspec.yaml`.
/// {@endtemplate}
enum AppAsset {
  /// The app icon.
  icon('assets/icon.png'),

  /// The illustration of the backup page.
  backup('assets/images/backup.png'),

  /// The illustration shown after a backup or photos are restored.
  restoredBackup('assets/images/restored-backup.png');

  /// {@macro app.AppAsset}
  new(this.path);

  /// The path of the file, relative to the package root.
  final String path;
}
