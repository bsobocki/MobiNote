import 'definitions/unicodes.dart';
import 'definitions/marks.dart';

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

String? elementPatternUnicodeChar(String char) {
  return String.fromCharCode(
      elementPatterns.indexOf(char) + elementPatternUnicodeNumber);
}

String? oneCharStyleMarkUnicodeChar(String char) {
  return String.fromCharCode(
      oneCharStyleMarks.indexOf(char) + oneCharStyleUnicodeNumber);
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

bool isOneCharStyleMarkCharacter(String char) {
  return oneCharStyleMarks.contains(char);
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

/*
widget tags don't have to check context to find out whether it is start or end
because after first new occurrence there have to be the next one as end
of widget

paragraph_fontSize: #size#
  example: #25#
    @size font size of the whole paragraph (TextField)
    8

web_link: (w)text:link(w)
  example: (w)some text:https://www.some.website.com(w)
    @text : visible clickable text
    @link : link to website

note_link: (n)id(n)
  example: (n)146(n)
    @id is an id in the database

image: (i)name(i)
  example: (i)capsule_tree.png(i)
    @name: name of file stored in images directory

note_widget: <n>id:width:height<n>
  example: <n>146:300:100<n>
    @id is an id in the database
    @width : widget width
    @height : widget height

may be useful sometime:

Map<String, String> specialCharConversion = {
  '\ue001': 'bold',
  '\ue002': 'italic',
  '\ue003': 'underline',
  '\ue004': 'strikethrough',
  '\ue005': 'web_link',
  '\ue006': 'note_link',
  '\ue007': 'checkbox',
  '\ue008': 'image',
  '\ue009': 'button',
  '\ue00a': 'header'
};
*/
