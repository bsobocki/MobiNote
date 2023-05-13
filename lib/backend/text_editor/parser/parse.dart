import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/span/span_info.dart';
import 'package:mobi_note/backend/text_editor/parser/style_conversion.dart';

class TextNoteContent {
  final String rawText;
  final List<InlineSpan> spans;

  TextNoteContent({required this.rawText, required this.spans});
}

TextNoteContent parseConversionMarkedText(String text) {
  List<InlineSpan> spans = [];
  List<SpanInfo> spanInfo = [];
  String rawText = "";

  for (int i = 0; i < text.length; i++) {
  }
  return TextNoteContent(rawText: rawText, spans: spans);
}
