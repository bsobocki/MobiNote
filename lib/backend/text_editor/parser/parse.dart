import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parser/definitions/types/decode.dart';
import 'package:mobi_note/backend/text_editor/parser/special_marks_operations/unicode.dart';

TextNoteContent parseUnicodeMarkedText(String text) {
  List<InlineSpan> spans = [];
  String rawText = "";
  SpanInfo currentSpan = SpanInfo(type: 'text');
  List<SpanInfo> spansInfo = [];

  for (int i = 0; i < text.length; i++) {
    var char = text[i];
    if (isUnicodeStartSyleCharacter(char)) {
      var spanInfo = SpanInfo(type: decodeStyleType(char));
    }
    if (isUnicodeEndStyleCharacter(char)) {}
    if (isUnicodeWidgetCharacter(char)) {}
    if (isUnicodeParagraphStyleCharacter(char)) {}
    if (isUnicodeElementPatternCharacter(char)) {}
  }
  return TextNoteContent(rawText: rawText, spans: spans);
}

class TextNoteContent {
  final String rawText;
  final List<InlineSpan> spans;

  TextNoteContent({required this.rawText, required this.spans});
}

class SpanInfo {
  String type;
  late String text;
  late List<SpanInfo> children;
  late SpanInfo parent;

  SpanInfo({required this.type});
}
