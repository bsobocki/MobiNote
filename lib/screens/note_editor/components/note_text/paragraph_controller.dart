import 'package:flutter/material.dart';
import 'package:mobi_note/logic/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/text_editor/parser/span_info_converterer.dart';
import '../../../../logic/text_editor/parser/mark_text_converter.dart';

class ParagraphController extends TextEditingController {
  final int id;
  TextSpan paragraph = const TextSpan(text: "Enter a note");
  void Function(double) resizeTextField;
  bool isFocused = false;

  StyledTextToUtfConverter textToUtfConverter = StyledTextToUtfConverter();
  UnicodeMarkedTextParser utfTextParser = UnicodeMarkedTextParser();
  SpanInfoConverter spanInfoConverter = SpanInfoConverter();

  ParagraphController({required this.id, required this.resizeTextField});

  TextSpan parseText() {
    int cursorPosition = selection.baseOffset;
    var unicodeMarkedText = 
        textToUtfConverter.textWithConvertedMarks(text, cursorPosition: cursorPosition, showParagraphChars: isFocused);
    var spanInfoParsedContent =
        utfTextParser.parseUnicodeMarkedText(unicodeMarkedText, showParagraphChars: isFocused);
    var spanTree = spanInfoConverter.getSpans(spanInfoParsedContent.spanInfo)
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
