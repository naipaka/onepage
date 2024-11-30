import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

/// Diary list tile.
class DiaryListTile extends StatefulWidget {
  /// Creates a diary list tile.
  const DiaryListTile({
    super.key,
    required this.content,
    required this.save,
  });

  /// Content of the diary.
  final String? content;

  /// Save diary content callback.
  final ValueChanged<String> save;

  @override
  State<DiaryListTile> createState() => _DiaryListTileState();
}

class _DiaryListTileState extends State<DiaryListTile>
    with WidgetsBindingObserver {
  /// Diary content text controller.
  late final textController = TextEditingController(text: widget.content);

  /// An instance of FocusNode to monitor the state of focus.
  final _focusNode = FocusNode();

  /// An instance of Debounce to delay the processing after input.
  final _debounce = Debounce(delay: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final shouldSave = [
      AppLifecycleState.paused,
      AppLifecycleState.inactive,
      AppLifecycleState.detached,
    ].contains(state);
    if (shouldSave) {
      _save();
    }
  }

  /// Save diary content.
  void _save() {
    if (textController.text == widget.content) {
      // When the content is not changed, do nothing.
      return;
    }
    widget.save(textController.text);
  }

  /// Focus change event handler.
  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextField(
      controller: textController,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: textTheme.bodyLarge,
      minLines: 3,
      maxLines: null,
      onChanged: (_) => _debounce(_save),
      onTapOutside: (_) => _focusNode.unfocus(),
    );
  }
}
