import 'package:flutter_test/flutter_test.dart';
import 'package:utils/src/extension/src/string_extension.dart';

void main() {
  group('StringExtension', () {
    group('trimAtMaxLength', () {
      test(
        'If a string containing emojis exceeds the specified maximum length, '
        'it should be truncated to the specified length and then appended with '
        '`...`',
        () {
          final emoji = '😀😃😄😁'.trimAtMaxLength(4);
          final textAndEmoji = '😀😃a😄😁😆'.trimAtMaxLength(5);
          final text = 'abcdef'.trimAtMaxLength(2);

          expect(emoji, '😀😃😄😁');
          expect(textAndEmoji, '😀😃a😄...');
          expect(text, 'a...');
          expect(''.trimAtMaxLength(2), '');
        },
      );

      test('An exception should be thrown if an invalid maximum length is '
          'specified', () {
        const errorText = 'abcdef';
        expect(() => errorText.trimAtMaxLength(-1), throwsArgumentError);
        expect(() => errorText.trimAtMaxLength(0), throwsArgumentError);
      });
    });
  });
}
