import 'dart:math';

import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/text_editor/definitions/paragraph_textstyle_mapping/style_text_mapping.dart';

import '../../special_marks_operations/text.dart';
import '../../definitions/paragraph_textstyle_mapping/paragraph_to_type.dart';


String firstMatch(String text, int i, Iterable<String> patterns) {
  return patterns.firstWhere(
    (element) => i + element.length <= text.length && element == text.substring(i, i + element.length),
    orElse: () => '',
  );
}

String characterContext(String text, int i) {
  return text.substring(
    max(0, i - 1),
    min(text.length, i + 2),
  );
}

String getTag(String text, int i) {
  return text.substring(i, min(text.length, i + 3));
}

int firstNonWhitespace(String text) {
  return text.replaceAll('\u200B', ' ').indexOf(RegExp('[^\\s]'));
}

String paragraphOf(String text, int startIndex) {
  int index = startIndex;
  List<String> paragraph = [];
  while (isParagraphChar(text[index])) {
    if ((paragraph += [text[index++]]).length >= 4) break;
    if (index >= text.length) break;
  }
  return paragraph.join('');
}

double paragraphFontSize(String text) {
  var startIndex = firstNonWhitespace(text);
  if (startIndex != -1 && isParagraphChar(text[startIndex])) {
    var paragraph = paragraphOf(text, startIndex);
    if (text.substring(startIndex + paragraph.length).isNotEmpty) {
      var paragraphType = paragraphCharsToType(paragraph);
      var fontSize = textStyles[paragraphType]!.fontSize;
      return fontSize ?? paragraphDefaultFontSize;
    }
  }
  return paragraphDefaultFontSize;
}
