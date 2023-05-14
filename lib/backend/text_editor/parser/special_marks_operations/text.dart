import '../definitions/unicodes.dart';
import '../definitions/marks.dart';

String? startStyleUnicodeChar(String char) {
  return String.fromCharCode(styleChars.indexOf(char) * 2 + styleUnicodeNumber);
}

String? endStyleUnicodeChar(String char) {
  return String.fromCharCode(
      styleChars.indexOf(char) * 2 + 1 + styleUnicodeNumber);
}

String? widgetUnicodeChar(String char) {
  return String.fromCharCode(widgetTags.indexOf(char) + widgetUnicodeNumber);
}

String? elementUnicodeChar(String char) {
  return String.fromCharCode(
      elementPatterns.indexOf(char) + elementUnicodeNumber);
}

String? paragraphStyleUnicodeChar(String char) {
  return String.fromCharCode(
      paragraphStyleChars.indexOf(char) + paragraphUnicodeNumber);
}

bool isStyleBoundaryCharacter(String char) {
  return styleChars.contains(char);
}

bool matchesStyleStart(String context) {
  return context.length != 2 &&
      isStyleBoundaryCharacter(context[1]) &&
      !isWhitespace(context[2]);
}

bool matchesStyleEnd(String context) {
  return !isWhitespace(context[0]) && isStyleBoundaryCharacter(context[1]);
}

Iterable<String> widgetTagsStartingFrom(String char) {
  return widgetTags.where((e) => e[0] == char);
}

Iterable<String> elementPatternsStartingFrom(String char) {
  return elementPatterns.where((e) => e[0] == char);
}

bool isParagraphStyleCharacter(String char) {
  return paragraphStyleChars.contains(char);
}

bool isWhitespace(String c) {
  return RegExp(r'\s').hasMatch(c);
}

class StyleInfo {
  int startIndex = -1;
  int endIndex = -1;
  String style;

  StyleInfo({required this.style});

  int get start => startIndex;
  int get end => endIndex;
  set start(int newStartIndex) => startIndex = newStartIndex;
  set end(int newEndIndex) => endIndex = newEndIndex;
}
