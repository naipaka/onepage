import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider_utils/src/package_info_provider.dart';

import '../util/mock.mocks.dart';
import '../util/provider_container.dart';

void main() {
  group('packageInfoProvider', () {
    test('Initial state of packageInfoProvider should throw UnimplementedError',
        () {
      final container = createContainer();
      expect(
        () => container.read(packageInfoProvider),
        throwsUnimplementedError,
      );
    });

    test('packageInfoProvider should return PackageInfo instance', () async {
      final mockPackageInfo = MockPackageInfo();
      when(mockPackageInfo.appName).thenReturn('Test App');
      when(mockPackageInfo.packageName).thenReturn('com.example.test');
      when(mockPackageInfo.version).thenReturn('1.0.0');
      when(mockPackageInfo.buildNumber).thenReturn('1');

      final container = createContainer(
        overrides: [
          packageInfoProvider.overrideWithValue(mockPackageInfo),
        ],
      );

      final packageInfo = container.read(packageInfoProvider);
      expect(packageInfo.appName, 'Test App');
      expect(packageInfo.packageName, 'com.example.test');
      expect(packageInfo.version, '1.0.0');
      expect(packageInfo.buildNumber, '1');
    });
  });
}
