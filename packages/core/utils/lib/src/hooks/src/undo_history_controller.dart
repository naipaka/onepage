import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates an [UndoHistoryController] that will be disposed automatically.
///
/// See also:
/// - [UndoHistoryController]
UndoHistoryController useUndoHistoryController({
  UndoHistoryValue? value,
  List<Object?>? keys,
}) {
  return use(
    _UndoHistoryControllerHook(
      value: value,
      keys: keys,
    ),
  );
}

class _UndoHistoryControllerHook extends Hook<UndoHistoryController> {
  const _UndoHistoryControllerHook({
    this.value,
    super.keys,
  });

  /// The value used to seed the history on construction.
  final UndoHistoryValue? value;

  @override
  HookState<UndoHistoryController, Hook<UndoHistoryController>> createState() =>
      _UndoHistoryControllerHookState();
}

class _UndoHistoryControllerHookState
    extends HookState<UndoHistoryController, _UndoHistoryControllerHook> {
  late final UndoHistoryController controller = UndoHistoryController(
    value: hook.value,
  );

  @override
  UndoHistoryController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useUndoHistoryController';
}
