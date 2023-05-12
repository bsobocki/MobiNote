import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parse.dart';

import '../../../backend/text_editor/span/span_info.dart';
import '../../../backend/text_editor/style/special_characters.dart';

class ParagraphController extends TextEditingController {
  late String markdownText;

  ParagraphController() {
    markdownText = text;
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    List<InlineSpan> children = parseConversionMarkedText(markdownText);
    return TextSpan(style: style, children: children);
  }
}
