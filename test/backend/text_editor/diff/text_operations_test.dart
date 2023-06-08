import 'package:test/test.dart';

// getStyledTextIndexOf(String unicodeMarkedText, int rawTextIndex)

void main() {
  test('get index of the marked text based on the position in raw text ', () {
    String markedText = 'This is (n)link:note(n) and text';
    String unicodeText = 'This is \ue101link:note\ue101 and text';
    String rawText = 'This is ';
  });
}
