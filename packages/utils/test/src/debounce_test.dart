import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';
import 'package:utils/src/debounce.dart';

void main() {
  group('Debounce', () {
    test('Callback is executed if the elapsed time is greater than the delay',
        () {
      fakeAsync((async) {
        final debounce = Debounce(delay: const Duration(milliseconds: 100));
        var callbackExecuted = false;

        debounce(() {
          callbackExecuted = true;
        });

        expect(callbackExecuted, false);

        async.elapse(const Duration(milliseconds: 101));

        expect(callbackExecuted, true);
      });
    });

    test('Callback is executed if the elapsed time is exactly the delay', () {
      fakeAsync((async) {
        final debounce = Debounce(delay: const Duration(milliseconds: 100));
        var callbackExecuted = false;

        debounce(() {
          callbackExecuted = true;
        });

        expect(callbackExecuted, false);

        async.elapse(const Duration(milliseconds: 100));

        expect(callbackExecuted, true);
      });
    });

    test('Callback is not executed if the elapsed time is less than the delay',
        () {
      fakeAsync((async) {
        final debounce = Debounce(delay: const Duration(milliseconds: 100));
        var callbackExecuted = false;

        debounce(() {
          callbackExecuted = true;
        });

        expect(callbackExecuted, false);

        async.elapse(const Duration(milliseconds: 99));

        expect(callbackExecuted, false);
      });
    });

    test(
        'Only the last callback is executed if multiple calls are made quickly',
        () {
      fakeAsync((async) {
        final debounce = Debounce(delay: const Duration(milliseconds: 100));
        var callbackText = 'Hello';

        debounce(() => callbackText = '!');
        debounce(() => callbackText = '.');
        debounce(() => callbackText = 'World');

        expect(callbackText, 'Hello');

        async.elapse(const Duration(milliseconds: 100));

        expect(callbackText, 'World');
      });
    });

    test('Callback is not executed if the dispose method is called', () {
      fakeAsync((async) {
        final debounce = Debounce(delay: const Duration(milliseconds: 100));
        var callbackExecuted = false;

        debounce(() {
          callbackExecuted = true;
        });

        debounce.dispose();

        async.elapse(const Duration(milliseconds: 100));

        expect(callbackExecuted, false);
      });
    });
  });
}
