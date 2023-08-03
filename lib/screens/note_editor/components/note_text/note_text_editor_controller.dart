import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/definitions/paragraph_textstyle_mapping/style_text_mapping.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/span_info_converterer.dart';
import '../../../../logic/note_editor/text_editor/parser/mark_text_converter.dart';

class NoteTextEditingController extends TextEditingController {
  String mainType = '';
  void Function(double) resizeTextField;
  bool isFocused = false;

  NoteTextEditingController({required this.resizeTextField});

  void setMainType(String newType) {
    mainType = newType;
  }

  TextSpan parseText() {
    int cursorPosition = selection.baseOffset;

    var unicodeMarkedText = StyledTextToUtfConverter().textWithConvertedMarks(
        text,
        cursorPosition: cursorPosition,
        showParagraphChars: isFocused);

    var spanInfoParsedContent = UnicodeMarkedTextParser()
        .parseUnicodeMarkedText(unicodeMarkedText,
            showParagraphChars: isFocused);

    var spanTree = SpanInfoConverter().getSpans(spanInfoParsedContent.spanInfo)
        as TextSpan;

    if (mainType.isNotEmpty) {
      spanTree = TextSpan(
          style: spanTree.style!.merge(textStyles[mainType]),
          children: spanTree.children,
          text: spanTree.text);
    }

    if (spanTree.style!.fontSize != null) {
      resizeTextField(spanTree.style!.fontSize!);
    }
    return spanTree;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    return parseText();
  }
}
