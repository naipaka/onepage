import 'package:configurator/configurator.dart';
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';

@GenerateNiceMocks([
  MockSpec<PackageInfo>(),
  MockSpec<Configurator>(),
])
void main() {}
