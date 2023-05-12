import 'package:flutter/material.dart';

Map<String, TextStyle> textStyles = {
  'bold': const TextStyle(fontWeight: FontWeight.bold),
  'italic': const TextStyle(fontStyle: FontStyle.italic),
  'underline': const TextStyle(decoration: TextDecoration.underline),
  'strikethrough': const TextStyle(decoration: TextDecoration.lineThrough)
};

bool isStyledText(String type) {
  return textStyles.containsKey(type);
}