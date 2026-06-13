#!/usr/bin/env bash
# PostToolUse hook: auto-format Dart files edited by Claude Code.
# Reads the hook event JSON from stdin, extracts the edited file path,
# and runs `dart format` on it. Always exits 0 so a formatting failure
# never blocks the session (CI's `melos run format:ci` is the gate).
set -u

input=$(cat)

file_path=$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)

case "$file_path" in
  *.dart) ;;
  *) exit 0 ;;
esac

[ -f "$file_path" ] || exit 0

# Generated files are formatted by build_runner; skip them.
case "$file_path" in
  *.g.dart | *.freezed.dart | *.gr.dart) exit 0 ;;
esac

if command -v fvm >/dev/null 2>&1; then
  fvm dart format "$file_path" >/dev/null 2>&1
elif command -v dart >/dev/null 2>&1; then
  dart format "$file_path" >/dev/null 2>&1
fi

exit 0
