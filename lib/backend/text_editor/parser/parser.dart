import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parser/definitions/types/decode.dart';
import 'package:mobi_note/backend/text_editor/parser/special_marks_operations/unicode.dart';

class Parser {
  List<InlineSpan> spans = [];
  List<String> rawTextBuff = [];
  List<SpanInfo> spansInfos = [];
  List<String> currTextBuff = [];

  Parser();

  void clearData() {
    spans.clear();
    rawTextBuff.clear();
    spansInfos.clear();
    currTextBuff.clear();
  }

  String get rawText => rawTextBuff.join('');

  void setParagraph(String type) {
    switch (type) {
      case 'header':
        break;
      case 'quote':
        break;
      case 'latex':
        break;
    }
  }

  void addTextSpan(String text) {}

  void addWidget(String type, String text) {}

  void addElement(String type, String text) {}

  String currTextFlush() {
    String text = currTextBuff.join('');
    currTextBuff.clear();
    return text;
  }

  TextNoteContent parseUnicodeMarkedText(String text) {
    SpanInfo mainSpan = SpanInfo(type: 'paragraph');
    SpanInfo currentSpan;
    clearData();

    if (isUnicodeParagraphStyleCharacter(text[0])) {
      setParagraph(decodeParagraphType(text[0]));
    }

    for (int i = 0; i < text.length; i++) {
      var char = text[i];
      if (isSpecialUnicode(char)) {
        if (isUnicodeStartSyleCharacter(char)) {
          var spanInfo = SpanInfo(type: decodeStyleType(char));
        }
        if (isUnicodeEndStyleCharacter(char)) {}
        if (isUnicodeWidgetCharacter(char)) {}
        if (isUnicodeElementPatternCharacter(char)) {}
      }
      currTextBuff.add(char);
    }

    //if
    return TextNoteContent(rawText: rawText, spans: spans);
  }
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
