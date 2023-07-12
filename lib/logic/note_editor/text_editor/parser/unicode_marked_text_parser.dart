import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/helpers/decode.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/definitions/types/text_types.dart';
import 'package:mobi_note/logic/note_editor/text_editor/special_marks_operations/text.dart';
import 'package:mobi_note/logic/note_editor/text_editor/special_marks_operations/unicode.dart';
import 'definitions/span_info.dart';
import 'helpers/paragraph_analyze.dart';

const String placeholder = '\u200b';

class UnicodeMarkedTextParser {
  late SpanInfo mainSpan;
  late SpanInfo currentSpan;
  List<String> rawTextBuff = [];
  List<SpanInfo> spansInfos = [];
  List<String> currTextBuff = [];
  int startIndex = 0;

  UnicodeMarkedTextParser();

  TextNoteSpanInfoContent parseUnicodeMarkedText(String text,
      {bool showParagraphChars = false}) {
    if (text.isEmpty || text == placeholder) {
      return TextNoteSpanInfoContent(
          rawText: text, spanInfo: SpanInfo(type: 'paragraph'));
    }

    init();
    addFirstWhitespacesIntoTextBuffers(text);

    if (startIndex >= text.length) {
      return TextNoteSpanInfoContent(
          rawText: text, spanInfo: SpanInfo(type: 'paragraph'));
      ;
    }

    if (isUnicodeParagraphStyleCharacter(text[startIndex])) {
      setParagraph(decodeParagraphType(text[startIndex]));
      if (showParagraphChars) {
        flushCurrentTextBuff();
        addSpanWithType('paragraph_chars');
        var paragraphChars = decodeParagraphStyleChars(text[startIndex]);
        currentSpan.text += paragraphChars;
        currentSpan = currentParent.parent;
        startIndex += paragraphChars.length;
      } else {
        while (startIndex < text.length &&
            isUnicodeParagraphStyleCharacter(text[startIndex])) {
          mainSpan.text += placeholder;
          startIndex++;
        }
      }
    }

    for (int i = startIndex; i < text.length; i++) {
      var char = text[i];
      if (isSpecialUnicode(char)) {
        if (isUnicodeStartSyleCharacter(char)) {
          if (textInBuffer) flushCurrentTextBuff();
          addSpanWithType(decodeStyleType(char));
          currTextBuff.add(placeholder);
        } else if (isUnicodeEndStyleCharacter(char)) {
          currTextBuff.add(placeholder);
          if (textInBuffer) flushCurrentTextBuff();
          setCurrentSpanAsParentof(decodeStyleType(char));
        } else if (isUnicodeWidgetCharacter(char)) {
          if (textInBuffer) flushCurrentTextBuff();
          addSpanWithType(decodeWidgetType(char));
          currTextBuff.add(placeholder);
          while (++i < text.length && !isUnicodeWidgetCharacter(text[i])) {
            currTextBuff.add(text[i]);
          }
          currTextBuff.add(placeholder);
          flushCurrentTextBuff();
          setCurrentSpanAsParentof(decodeWidgetType(char));
        } else if (isUnicodeElementPatternCharacter(char)) {
          addSpanWithType(decodeElementType(char));
          currTextBuff.add(placeholder);
        }
      } else {
        if (currentSpan.children.isNotEmpty) addSpanWithType('text');
        rawTextBuff.add(char);
        currTextBuff.add(char);
      }
    }
    if (textInBuffer) flushCurrentTextBuff();

    return TextNoteSpanInfoContent(rawText: rawText, spanInfo: mainSpan);
  }

  void init() {
    mainSpan = SpanInfo(type: 'paragraph');
    currentSpan = mainSpan;
    startIndex = 0;
    rawTextBuff.clear();
    spansInfos.clear();
    currTextBuff.clear();
  }

  void addFirstWhitespacesIntoTextBuffers(String text) {
    while (startIndex < text.length && isWhitespace(text[startIndex])) {
      currTextBuff.add(text[startIndex]);
      rawTextBuff.add(text[startIndex]);
      startIndex++;
    }
  }

  String get rawText => rawTextBuff.join('');
  SpanInfo get currentParent =>
      currentSpan.type == 'text' ? currentSpan.parent : currentSpan;
  bool get needSpanForText => currentSpan.children.isNotEmpty;
  bool get textInBuffer => currTextBuff.isNotEmpty;

  bool isTextSpan(String type) {
    return type == 'text' || styleTypes.contains(type);
  }

  void setParagraph(String type) {
    mainSpan = SpanInfo(type: type);
    currentSpan = mainSpan;
  }

  void setCurrentSpanAsParentof(String type) {
    SpanInfo span = currentSpan;
    while (span.type != type) {
      span = span.parent;
    }
    currentSpan = span.parent;
  }

  void addSpanWithType(String type) {
    var span = SpanInfo(type: type);
    span.parent = currentParent;
    span.parent.children += [span];
    if (type != 'element') {
      currentSpan = span;
    }
  }

  void flushCurrentTextBuff() {
    currentSpan.text += currTextBuff.join('');
    currTextBuff.clear();
  }
}

class TextNoteSpanInfoContent {
  final String rawText;
  final SpanInfo spanInfo;

  TextNoteSpanInfoContent({required this.rawText, required this.spanInfo});
}
