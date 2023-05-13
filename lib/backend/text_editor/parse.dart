import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/span/span_info.dart';
import 'package:mobi_note/backend/text_editor/style/special_characters.dart';

bool found(int index) {
  return index != -1;
}

String textWithConvertedMarks(String text) {
  List<String> textBuff = [];
  List<SpecialCharInfo> startBounds = [];

  for (int i = 0; i < text.length; i++) {
    var character = text[i];
    if (isOneCharStyleMarkCharacter(character)) {
      textBuff.add(oneCharStyleMarkConversion[character]!);
      continue;
    }
    if (isStyleBoundaryCharacter(character)) {
      var context = getContext(text, i);
      if (matchesStyleEnd(context)) {
        var boundIndex = startBounds.indexWhere((e) => e.char == character);
        if (found(boundIndex)) {
          var startBoundIndex = startBounds[boundIndex].index;
          textBuff[startBoundIndex] = startStyleCharConversion[character]!;
          textBuff.add(endStyleCharConversion[character]!);
          startBounds.removeAt(boundIndex);
          continue;
        }
      }
      if (matchesStyleStart(context)) {
        startBounds.add(SpecialCharInfo(index: i, char: character));
      }
    }

    var tags = widgetTagsStartingFrom(character);
    if (tags.isNotEmpty) {
      var pattern = firstMatch(text, i, tags);
      if (pattern.isNotEmpty) {
        textBuff.add(widgetTagConversion[pattern]!);
        i += pattern.length - 1;
        continue;
      }
    }
    textBuff.add(character);
  }

  return textBuff.join('');
}

List<InlineSpan> parseConversionMarkedText(String text) {
  List<InlineSpan> spans = [];
  List<SpanInfo> spanInfo = [];
  String rawText = "";

  for (int i = 0; i < text.length; i++) {
    String style = styleDecode(text[i]);
  }
  return spans;
}

String firstMatch(String text, int i, Iterable<String> patterns) {
  return patterns.firstWhere(
    (element) => element == text.substring(i, i + element.length),
    orElse: () => '',
  );
}

String getContext(String text, int i) {
  return text.substring(
    max(0, i - 1),
    min(text.length, i + 2),
  );
}

String getTag(String text, int i) {
  return text.substring(i, min(text.length, i + 3));
}
