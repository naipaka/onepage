import 'package:flutter/material.dart';

/// Extension methods for the String class.
extension StringExtension on String {
  /// Trims the string to a maximum length,
  /// counting each emoji as a single character.
  ///
  /// If the string exceeds the [maxLength],
  /// it truncates the string to [maxLength - 1]
  /// characters and appends `...` at the end.
  ///
  /// - Parameter maxLength: The maximum length of the string
  ///   including the ellipsis.
  /// - Returns: A string that is at most [maxLength] characters long,
  ///   with `...` appended if it was truncated.
  String trimAtMaxLength(int maxLength) {
    return characters.length > maxLength
        ? '${characters.getRange(0, maxLength - 1)}...'
        : this;
  }
}
