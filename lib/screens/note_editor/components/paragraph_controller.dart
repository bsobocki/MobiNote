import 'package:flutter/material.dart';
import 'package:mobi_note/logic/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/text_editor/parser/span_info_converterer.dart';
import '../../../logic/text_editor/parser/mark_text_converter.dart';

class ParagraphController extends TextEditingController {
  TextSpan paragraph = const TextSpan(text: "Enter a note");
  void Function(double) resizeTextField;

  ParagraphController({required this.resizeTextField});

  TextSpan parseText() {
    int cursorPosition = selection.baseOffset;
    var unicodeMarkedText = StyledTextConverter()
        .textWithConvertedMarks(text, cursorPosition: cursorPosition);
    var spanInfoParsedContent =
        UnicodeMarkedTextParser().parseUnicodeMarkedText(unicodeMarkedText);
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
