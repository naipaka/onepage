import 'package:anchor_list_view/anchor_list_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnchorItemPosition', () {
    AnchorItemPosition position({
      int index = 1,
      double leadingEdge = 0.25,
      double trailingEdge = 0.5,
    }) => AnchorItemPosition(
      index: index,
      leadingEdge: leadingEdge,
      trailingEdge: trailingEdge,
    );

    test('equals a position with the same values', () {
      expect(position(), position());
      expect(position().hashCode, position().hashCode);
    });

    test('differs from a position with another value', () {
      expect(position(index: 2), isNot(position()));
      expect(position(leadingEdge: 0), isNot(position()));
      expect(position(trailingEdge: 1), isNot(position()));
    });
  });
}
