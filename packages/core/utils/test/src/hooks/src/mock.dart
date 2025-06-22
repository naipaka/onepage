import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

export 'package:flutter_test/flutter_test.dart'
    hide
        Fake,
        Func0,
        Func1,
        Func2,
        Func3,
        Func4,
        Func5,
        // ignore: Fake is only available in master
        Func6;
export 'package:mockito/mockito.dart';

class HookTest<R> extends Hook<R?> {
  const HookTest({
    this.build,
    this.dispose,
    this.initHook,
    this.didUpdateHook,
    this.reassemble,
    this.createStateFn,
    this.didBuild,
    this.deactivate,
    super.keys,
  });

  final R Function(BuildContext context)? build;
  final void Function()? dispose;
  final void Function()? didBuild;
  final void Function()? initHook;
  final void Function()? deactivate;
  final void Function(HookTest<R> previousHook)? didUpdateHook;
  final void Function()? reassemble;
  final HookStateTest<R> Function()? createStateFn;

  @override
  HookStateTest<R> createState() =>
      createStateFn != null ? createStateFn!() : HookStateTest<R>();
}

class HookStateTest<R> extends HookState<R?, HookTest<R>> {
  @override
  void initHook() {
    super.initHook();
    hook.initHook?.call();
  }

  @override
  void dispose() {
    hook.dispose?.call();
  }

  @override
  void didUpdateHook(HookTest<R> oldHook) {
    super.didUpdateHook(oldHook);
    hook.didUpdateHook?.call(oldHook);
  }

  @override
  void reassemble() {
    super.reassemble();
    hook.reassemble?.call();
  }

  @override
  void deactivate() {
    super.deactivate();
    hook.deactivate?.call();
  }

  @override
  R? build(BuildContext context) {
    if (hook.build != null) {
      return hook.build!(context);
    }
    return null;
  }
}

Element _rootOf(Element element) {
  late Element root;
  element.visitAncestorElements((e) {
    root = e;
    return true;
  });
  return root;
}

void hotReload(WidgetTester tester) {
  final root = _rootOf(tester.allElements.first);

  TestWidgetsFlutterBinding.ensureInitialized().buildOwner?.reassemble(root);
}

class MockSetState extends Mock {
  void call();
}

class MockInitHook extends Mock {
  void call();
}

class MockCreateState<T extends HookState<dynamic, Hook<Object?>>>
    extends Mock {
  MockCreateState(this.value);

  final T value;

  T call() {
    return super.noSuchMethod(
          Invocation.method(#call, []),
          returnValue: value,
          returnValueForMissingStub: value,
        )
        as T;
  }
}

class MockBuild<T> extends Mock {
  T call(BuildContext? context);
}

class MockDeactivate extends Mock {
  void call();
}

class MockFlutterErrorDetails extends Mock implements FlutterErrorDetails {
  @override
  String toString({DiagnosticLevel? minLevel}) => super.toString();
}

class MockErrorBuilder extends Mock {
  Widget call(FlutterErrorDetails error) =>
      super.noSuchMethod(
            Invocation.getter(#call),
            returnValue: Container(),
          )
          as Widget;
}

class MockOnError extends Mock {
  void call(FlutterErrorDetails? error);
}

class MockReassemble extends Mock {
  void call();
}

class MockDidUpdateHook extends Mock {
  void call(HookTest<Object?>? hook);
}

class MockDispose extends Mock {
  void call();
}
