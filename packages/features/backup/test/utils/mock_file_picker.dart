import 'package:file_picker/file_picker.dart';

FilePickerResult? _mockResult;

/// Set mock result
void setMockFilePickerResult(FilePickerResult? result) {
  _mockResult = result;
}

/// Fake class that extends FilePicker
class FakeFilePicker extends FilePicker {
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    void Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    return _mockResult;
  }
}

void setUpMockFilePicker() {
  FilePicker.platform = FakeFilePicker();
}

void tearDownMockFilePicker() {
  _mockResult = null;
}
