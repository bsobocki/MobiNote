import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/parser/definitions/flutter_elements_mapping/style_text_mapping.dart';
import 'package:mobi_note/backend/text_editor/parser/definitions/span_info.dart';
import 'package:mobi_note/backend/text_editor/parser/parser.dart';
import 'package:test/test.dart';

bool sameChildren(List<InlineSpan>? a, List<InlineSpan>? b) {
  if (a == null) return b == null || b.isEmpty; //TextSpan have null as uninitialized children
  if (b == null) return a.isEmpty;              // but SpanInfo has empty list
  if (a.length != b.length) return false;
  bool result = true;
  for (int i = 0; i < a.length; i++) {
    result = result && isSame(a[i], b[i]);
  }
  return result;
}

bool isSame(InlineSpan a, InlineSpan b) {
  if (a.runtimeType != b.runtimeType) return false;
  if (a is TextSpan && b is TextSpan) {
    return a.toString() == b.toString() && sameChildren(a.children, b.children);
  }
  if (a is WidgetSpan && b is WidgetSpan) {
    print(a.toString());
    print(b.toString());
    return a.toString() == b.toString();
  }
  return false;
}

void addChild(SpanInfo span, SpanInfo child) {
  span.children += [child];
}

SpanInfo TextSpanInfo(String text) {
  SpanInfo span = SpanInfo(type: 'text');
  span.text = text;
  return span;
}

void main() {
  test("parse span info structure", () {
    SpanInfo paragraph = SpanInfo(
      type: 'header3',
      children: [
        SpanInfo(type: 'text', text: "to text"),
        SpanInfo(
          type: 'bold',
          children: [
            SpanInfo(
              type: 'italic',
              children: [
                SpanInfo(
                  type: 'text',
                  text: 'italic text',
                ),
              ],
            ),
            SpanInfo(
              type: 'text',
              text: 'only bold text',
            )
          ],
        )
      ],
    );

    var result = TextSpan(
      text: "",
      style: textStyles['header3'],
      children: [
        TextSpan(text: "to text"),
        TextSpan(
          text: "",
          style: textStyles["bold"],
          children: [
            TextSpan(
              text: "",
              style: textStyles['italic'],
              children: [
                TextSpan(text: "italic text"),
              ],
            ),
            TextSpan(text: "only bold text")
          ],
        )
      ],
    );

    Parser parser = Parser();

    expect(isSame(parser.getSpans(paragraph), result), true);
  });
}