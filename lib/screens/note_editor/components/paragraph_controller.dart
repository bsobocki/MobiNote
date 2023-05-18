import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parser/parser.dart';
import '../../../backend/text_editor/parser/mark_text.dart';

class ParagraphController extends TextEditingController {
  late String markdownText;

  ParagraphController() {
    markdownText = text;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    var markedText = StyledTextConverter().textWithConvertedMarks(markdownText);
    var parsedContent = Parser().parseUnicodeMarkedText(markedText);
    text = parsedContent.rawText;
    return parsedContent.span as TextSpan;
  }
}

