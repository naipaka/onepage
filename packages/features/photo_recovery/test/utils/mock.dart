import 'package:device_photos/device_photos.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_storage/photo_storage.dart';

class MockDevicePhotos extends Mock implements DevicePhotos;

class MockPhotoEncoder extends Mock implements PhotoEncoder;
