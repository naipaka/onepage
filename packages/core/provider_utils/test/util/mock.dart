import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_logger/simple_logger.dart';

@GenerateNiceMocks([
  MockSpec<PackageInfo>(),
  MockSpec<SimpleLogger>(),
])
void main() {}
