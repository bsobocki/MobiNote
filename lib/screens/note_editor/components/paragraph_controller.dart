import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/backend/text_editor/parser/span_info_converterer.dart';
import '../../../backend/text_editor/parser/mark_text.dart';

class ParagraphController extends TextEditingController {
  late String markdownText;

  ParagraphController() {
    markdownText = text;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    var unicodeMarkedText =
        StyledTextConverter().textWithConvertedMarks(markdownText);
    var spanInfoParsedContent =
        UnicodeMarkedTextParser().parseUnicodeMarkedText(unicodeMarkedText);
    text = spanInfoParsedContent.rawText;
    var paragraphTextSpan =
        SpanInfoConverter().getSpans(spanInfoParsedContent.spanInfo);
    return paragraphTextSpan as TextSpan;
  }
}
