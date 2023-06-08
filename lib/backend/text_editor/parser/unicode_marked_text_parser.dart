import 'package:mobi_note/backend/text_editor/parser/definitions/types/decode.dart';
import 'package:mobi_note/backend/text_editor/parser/definitions/types/text_types.dart';
import 'package:mobi_note/backend/text_editor/special_marks_operations/text.dart';
import 'package:mobi_note/backend/text_editor/special_marks_operations/unicode.dart';
import 'definitions/span_info.dart';

class UnicodeMarkedTextParser {
  SpanInfo mainSpan = SpanInfo(type: 'paragraph');
  late SpanInfo currentSpan;
  List<String> rawTextBuff = [];
  List<SpanInfo> spansInfos = [];
  List<String> currTextBuff = [];
  int startIndex = 0;

  UnicodeMarkedTextParser();

  TextNoteSpanInfoContent parseUnicodeMarkedText(String text) {
    if (text.isEmpty)
      return TextNoteSpanInfoContent(
          rawText: text, spanInfo: SpanInfo(type: 'paragraph'));

    init();
    addFirstWhitespacesIntoTextBuffers(text);

    if (isUnicodeParagraphStyleCharacter(text[startIndex])) {
      setParagraph(decodeParagraphType(text[startIndex]));
      startIndex++;
    }

    for (int i = startIndex; i < text.length; i++) {
      var char = text[i];
      if (isSpecialUnicode(char)) {
        if (isUnicodeStartSyleCharacter(char)) {
          if (textInBuffer) flushCurrentTextBuff();
          addSpan(decodeStyleType(char));
          currTextBuff.add('\u200B');
        } else if (isUnicodeEndStyleCharacter(char)) {
          currTextBuff.add('\u200B');
          if (textInBuffer) flushCurrentTextBuff();
          setCurrentSpanAsParentof(decodeStyleType(char));
        } else if (isUnicodeWidgetCharacter(char)) {
          if (textInBuffer) flushCurrentTextBuff();
          addSpan(decodeWidgetType(char));
          currTextBuff.add('\u200B');
          while (++i < text.length && !isUnicodeWidgetCharacter(text[i])) {
            currTextBuff.add(text[i]);
          }
          currTextBuff.add('\u200B');
          flushCurrentTextBuff();
          setCurrentSpanAsParentof(decodeWidgetType(char));
        } else if (isUnicodeElementPatternCharacter(char)) {
          addSpan(decodeElementType(char));
          currTextBuff.add('\u200B');
        }
      } else {
        if (currentSpan.children.isNotEmpty) addSpan('text');
        rawTextBuff.add(char);
        currTextBuff.add(char);
      }
    }
    if (textInBuffer) flushCurrentTextBuff();

    return TextNoteSpanInfoContent(rawText: rawText, spanInfo: mainSpan);
  }

  void init() {
    currentSpan = mainSpan;
    startIndex = 0;
    rawTextBuff.clear();
    spansInfos.clear();
    currTextBuff.clear();
  }

  void addFirstWhitespacesIntoTextBuffers(String text) {
    while (isWhitespace(text[startIndex])) {
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
  }

  void setCurrentSpanAsParentof(String type) {
    SpanInfo span = currentSpan;
    while (span.type != type) {
      span = span.parent;
    }
    currentSpan = span.parent;
  }

  void addSpan(String type) {
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
