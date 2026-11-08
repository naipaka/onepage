// `very_good test` compiles its test optimizer hook on the first run, and
// parallel runs across packages fail while compiling it at the same time
// (very_good_cli issue 947, mason issue 1655). CI runs `very_good test` here
// once so the parallel runs reuse the compiled hook.
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compiles the test optimizer hook', () {});
}
