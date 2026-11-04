import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart' show XFile;

PlatformFile? _mockResult;

/// Set mock result
void setMockFilePickerResult(PlatformFile? result) {
  _mockResult = result;
}

/// Fake [PlatformFile] backed by a local file path.
final class FakePlatformFile extends PlatformFile {
  new(String path) : uri = Uri.file(path);

  @override
  final Uri uri;

  @override
  String get name => uri.pathSegments.last;

  @override
  XFile get xFile => XFile(uri.toFilePath());

  @override
  int? lengthSync() => null;

  @override
  Future<int?> length() async => null;

  @override
  Future<Uint8List> readAsBytes() => File(uri.toFilePath()).readAsBytes();

  @override
  Stream<Uint8List> readAsByteStream() =>
      File(uri.toFilePath()).openRead().map(Uint8List.fromList);
}

class FakeFilePickerPlatform extends FilePickerPlatform {
  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    void Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    return _mockResult;
  }
}

void setUpMockFilePicker() {
  FilePickerPlatform.instance = FakeFilePickerPlatform();
}

void tearDownMockFilePicker() {
  _mockResult = null;
}
