import 'marks.dart';

const styleUnicodeNumber = 0xe000;
const widgetUnicodeNumber = 0xe100;
const elementPatternUnicodeNumber = 0xe1A0;
const oneCharStyleUnicodeNumber = 0xe200;

var styleUnicodeRange = UnicodeRange(
  unicode: styleUnicodeNumber,
  size: styleChars.length,
);

var oneCharStyleUnicodeRange = UnicodeRange(
  unicode: oneCharStyleUnicodeNumber,
  size: oneCharStyleMarks.length,
);

var elementPatternUnicodeRange = UnicodeRange(
  unicode: elementPatternUnicodeNumber,
  size: elementPatterns.length,
);

var widgetUnicodeRange = UnicodeRange(
  unicode: widgetUnicodeNumber,
  size: widgetTags.length,
);

class UnicodeRange {
  final int unicode;
  final int size;

  const UnicodeRange({required this.unicode, required this.size});
}
