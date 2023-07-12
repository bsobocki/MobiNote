import 'marks.dart';

const styleUnicodeNumber = 0xe000;
const widgetUnicodeNumber = 0xe100;
const elementUnicodeNumber = 0xe1A0;
const paragraphUnicodeNumber = 0xe200;

var styleUnicodeRange = UnicodeRange(
  unicode: styleUnicodeNumber,
  size: styleCharsAmount,
);

var paragraphStyleUnicodeRange = UnicodeRange(
  unicode: paragraphUnicodeNumber,
  size: paragraphStyleChars.length,
);

var elementPatternUnicodeRange = UnicodeRange(
  unicode: elementUnicodeNumber,
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
