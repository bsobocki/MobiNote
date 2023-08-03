import '../definitions/unicodes.dart';

int unicodeNumber(String char) {
  return char.codeUnitAt(0);
}

bool isSpecialUnicode(String char) {
  int num = unicodeNumber(char);
  return 0xe000 <= num && num <= 0xefff;
}

bool inUnicodeRange(int num, UnicodeRange range) {
  return range.unicode <= num && num < range.unicode + range.size;
}

bool isUnicodeStartSyleCharacter(String char) {
  int num = unicodeNumber(char);
  return inUnicodeRange(num, styleUnicodeRange) && num.isEven;
}

bool isUnicodeEndStyleCharacter(String char) {
  int num = unicodeNumber(char);
  return inUnicodeRange(num, styleUnicodeRange) && num.isOdd;
}

bool isUnicodeParagraphStyleCharacter(String char) {
  return inUnicodeRange(unicodeNumber(char), paragraphStyleUnicodeRange);
}

bool isUnicodeElementPatternCharacter(String char) {
  return inUnicodeRange(unicodeNumber(char), elementPatternUnicodeRange);
}

bool isUnicodeWidgetCharacter(String char) {
  return inUnicodeRange(unicodeNumber(char), widgetUnicodeRange);
}
