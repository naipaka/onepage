import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider_utils/src/package_info_provider.dart';

import '../util/mock_package_info.dart';
import '../util/provider_container.dart';

void main() {
  group('packageInfoInitializingProvider', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(setUpMockPackageInfo);

    tearDown(tearDownMockPackageInfo);

    test('The initial state of packageInfoInitializingProvider '
        'should return an instance of PackageInfo', () async {
      final container = createContainer();

      final packageInfo = await container.read(
        packageInfoInitializingProvider.future,
      );

      expect(packageInfo, isA<PackageInfo>());
    });
  });

  group('packageInfoProvider', () {
    test('packageInfoProvider should return PackageInfo instance', () async {
      final testPackageInfo = PackageInfo(
        appName: 'Test App',
        packageName: 'com.example.test',
        version: '1.0.0',
        buildNumber: '1',
      );

      final container = createContainer(
        overrides: [
          packageInfoInitializingProvider.overrideWith(
            (ref) => Future.syncValue(testPackageInfo),
          ),
        ],
      )..listen(packageInfoInitializingProvider, (_, _) {});

      await container.read(packageInfoInitializingProvider.future);

      final packageInfo = container.read(packageInfoProvider);
      expect(packageInfo.appName, 'Test App');
      expect(packageInfo.packageName, 'com.example.test');
      expect(packageInfo.version, '1.0.0');
      expect(packageInfo.buildNumber, '1');
    });
  });
}
