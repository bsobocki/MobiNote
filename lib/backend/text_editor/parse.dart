import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/span/span_info.dart';
import 'package:mobi_note/backend/text_editor/style/special_characters.dart';

String getContext(String text, int i) {
  return text.substring(
    max(0, i - 1),
    min(text.length, i + 2),
  );
}

String textWithConvertedMarks(String text) {
  List<String> signedTextBuff = [];
  List<SpecialCharInfo> startBounds = [];

  for (int i = 0; i < text.length; i++) {
    var character = text[i];
    if (isStyleBoundaryCharacter(character)) {
      var context = getContext(text, i);
      if (matchesStyleEnd(context)) {
        var boundIndex =
            startBounds.indexWhere((element) => element.char == character);
        if (boundIndex != -1) {
          var startBoundIndex = startBounds[boundIndex].index;
          signedTextBuff[startBoundIndex] =
              startStyleCharConversion[character]!;
          signedTextBuff.add(endStyleCharConversion[character]!);
          startBounds.removeAt(boundIndex);
          continue;
        }
      }
      if (matchesStyleStart(context)) {
        startBounds.add(SpecialCharInfo(index: i, char: character));
      }
    }
    signedTextBuff.add(character);
  }

  return signedTextBuff.join('');
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
