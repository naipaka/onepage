import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

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
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.content);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      widget.save(textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    return TextField(
      controller: textController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: typography.bodyM,
      minLines: 3,
      maxLines: null,
      onChanged: (value) {
        widget.save(value);
      },
      onTapOutside: (_) {
        widget.save(textController.text);
      },
    );
  }
}
