import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/span_info_converterer.dart';
import '../../../../logic/note_editor/text_editor/parser/mark_text_converter.dart';

class ParagraphController extends TextEditingController {
  final int id;
  TextSpan paragraph = const TextSpan(text: "Enter a note");
  void Function(double) resizeTextField;
  bool isFocused = false;

  ParagraphController({required this.id, required this.resizeTextField});

  TextSpan parseText() {
    int cursorPosition = selection.baseOffset;
    var unicodeMarkedText = 
        StyledTextToUtfConverter().textWithConvertedMarks(text, cursorPosition: cursorPosition, showParagraphChars: isFocused);
    var spanInfoParsedContent =
        UnicodeMarkedTextParser().parseUnicodeMarkedText(unicodeMarkedText, showParagraphChars: isFocused);
    var spanTree = SpanInfoConverter().getSpans(spanInfoParsedContent.spanInfo)
        as TextSpan;
    resizeTextField(spanTree.style!.fontSize!);
    return spanTree;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    return parseText();
  }
}
