import 'package:flutter/material.dart';

import '../../../backend/text_editing/span/span_info.dart';
import '../../../backend/text_editing/style/special_characters.dart';

class ParagraphController extends TextEditingController {
  late String markdownText;

  ParagraphController() {
    markdownText = text;
  }

  String signedText(String text) {
    String signed = "";

    for (int i = 0; i < text.length; i++) {
      if (isStyleSpecialCharacter(text[i])) {
        var context = text.substring(i-1, i+1);
        if (isOpening(context)){}
      }
    }

    return signed;
  }

  List<InlineSpan> parse(String text) {
    List<InlineSpan> spans = [];
    List<SpanInfo> spanInfo = [];
    String rawText = "";

    for (int i = 0; i < text.length; i++) {
      String style = styleDecode(text[i]);
    }
    return spans;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    List<InlineSpan> children = parse(markdownText);
    return TextSpan(style: style, children: children);
  }
}
