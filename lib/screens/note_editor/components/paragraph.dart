import 'package:flutter/material.dart';

bool val = true;

class ParagraphController extends TextEditingController {
  late final Pattern pattern;
  final Map<String, InlineSpan> mapping;

  ParagraphController({required this.mapping}) {
    pattern = RegExp(mapping.keys.map((key) => RegExp.escape(key)).join('|'));
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    List<InlineSpan> children = [];
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        children.add(mapping[match[0]] ?? const TextSpan(text: "failed"));
        return "";
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return "";
      },
    );
    return TextSpan(style: style, children: children);
  }
}
