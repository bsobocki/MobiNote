import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/backend/text_editor/parser/span_info_converterer.dart';
import '../../../backend/text_editor/parser/mark_text.dart';

class ParagraphController extends TextEditingController {
  String markedText = "";
  String unicodeMarkedText = "";
  String prevText = "";
  TextSpan paragraph = const TextSpan(text: "Enter a note");

  ParagraphController();

  TextSpan parseMarkdownText(String text) {
    int cursorPosition = selection.baseOffset;
    unicodeMarkedText =
        StyledTextConverter().textWithConvertedMarks(text, cursorPosition);
    print("PRINT: Unicode text: $unicodeMarkedText");
    print("PRINT: cursorPosition: $cursorPosition");
    var spanInfoParsedContent =
        UnicodeMarkedTextParser().parseUnicodeMarkedText(unicodeMarkedText);
    text = spanInfoParsedContent.rawText;
    prevText = text;
    // paragraph = SpanInfoConverter().getSpans(spanInfoParsedContent.spanInfo)
    //     as TextSpan;
    return SpanInfoConverter().getSpans(spanInfoParsedContent.spanInfo)
        as TextSpan;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    print("PRINT: Raw text: $text|");
    return parseMarkdownText(text);
  }
}
