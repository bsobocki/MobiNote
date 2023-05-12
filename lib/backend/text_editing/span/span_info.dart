import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editing/span/span_styles.dart';

class SpanInfo {
  String type;
  late String text;
  late List<SpanInfo> children;
  late SpanInfo parent;

  SpanInfo({required this.type});
}
