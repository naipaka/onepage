import 'package:test/test.dart';
import 'package:utils/src/extension/src/string_extension.dart';

void main() {
  group('StringExtension', () {
    group('trimAtMaxLength', () {
      test(
        '絵文字を含む文字列が指定された最大長を超える場合、指定された長さまで切り詰めてから `...` を付与すること',
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

      test('無効な最大長が指定された場合、例外をスローすること', () {
        const errorText = 'abcdef';
        expect(() => errorText.trimAtMaxLength(-1), throwsArgumentError);
        expect(() => errorText.trimAtMaxLength(0), throwsArgumentError);
      });
    });
  });
}
