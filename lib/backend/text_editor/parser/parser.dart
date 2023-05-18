import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parser/definitions/types/decode.dart';
import 'package:mobi_note/backend/text_editor/parser/special_marks_operations/unicode.dart';

import 'definitions/flutter_elements_mapping/style_text_mapping.dart';
import 'definitions/span_info.dart';
import 'definitions/types/element_types.dart';
import 'definitions/types/widget_types.dart';

class Parser {
  SpanInfo mainSpan = SpanInfo(type: 'paragraph');
  late SpanInfo currentSpan;
  List<String> rawTextBuff = [];
  List<SpanInfo> spansInfos = [];
  List<String> currTextBuff = [];

  Parser();

  void clearData() {
    rawTextBuff.clear();
    spansInfos.clear();
    currTextBuff.clear();
  }

  String get rawText => rawTextBuff.join('');

  void setParagraph(String type) {
    mainSpan = SpanInfo(type: type);
  }

  void addSpan(String text) {}

  String currTextFlush() {
    String text = currTextBuff.join('');
    currTextBuff.clear();
    return text;
  }

  InlineSpan getSpans(SpanInfo spanInfo) {
    List<InlineSpan> spanChildren =
        spanInfo.children.map((e) => getSpans(e)).toList();
    var type = spanInfo.type;

    if (widgetTypes.contains(type)) {
      Widget widget = Text(spanInfo.text);
      switch (type) {
        case 'web_link':
          widget = TextButton(
            onPressed: () => debugPrint("${spanInfo.text} clicked"),
            child: Text(
              spanInfo.text,
            ),
          );
          break;

        case 'note_link':
          widget = TextButton(
            onPressed: () => debugPrint(
                "note with id: ${spanInfo.text} should be opened :D"),
            child: Text(spanInfo.text),
          );
          break;

        case 'note_widget':
          widget = ElevatedButton(
            child: Text(spanInfo.text),
            onPressed: () =>
                debugPrint("this is note ${spanInfo.text} button!"),
          );
          break;

        case 'inline_Latex':
          widget = ElevatedButton(
              onPressed: () => debugPrint("not implemented latex widget"),
              child: const Text("LaTeX"));
          break;
      }
      return WidgetSpan(child: widget);
    }

    if (elementTypes.contains(type)) {
      Widget widget = Checkbox(value: false, onChanged: (val) {});
      switch (type) {
        case 'unselected_checkbox':
          widget = Checkbox(value: false, onChanged: (val) {});
          break;
        case 'selected_checkbox':
          widget = Checkbox(value: true, onChanged: (val) {});
          break;
        case 'image':
          widget = SizedBox(
            height: textStyles[mainSpan.type]!.fontSize,
            child: Image.asset(spanInfo.text),
          );
          break;
      }
      return WidgetSpan(child: widget);
    }

    return TextSpan(
        text: spanInfo.text, style: textStyles[type], children: spanChildren);
  }

  TextNoteContent parseUnicodeMarkedText(String text) {
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

    return TextNoteContent(rawText: rawText, span: getSpans(mainSpan));
  }
}

class TextNoteContent {
  final String rawText;
  final InlineSpan span;

  TextNoteContent({required this.rawText, required this.span});
}
