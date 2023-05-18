import 'package:flutter/material.dart';

Map<String, TextStyle> textStyles = {
  'bold': const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  'italic': const TextStyle(
    fontStyle: FontStyle.italic,
  ),
  'underline': const TextStyle(
    decoration: TextDecoration.underline,
  ),
  'strikethrough': const TextStyle(
    decoration: TextDecoration.lineThrough,
  ),
  'inline_code': TextStyle(
    fontFamily: 'Courier New',
    decorationColor: Colors.black,
    backgroundColor: Colors.grey[300],
    color: Colors.black,
  ),
  'header1': const TextStyle(
    fontSize: 30.0,
  ),
  'header2': const TextStyle(
    fontSize: 26.0,
  ),
  'header3': const TextStyle(
    fontSize: 22.0,
  ),
  'header4': const TextStyle(
    fontSize: 18.0,
  ),
  'quote': TextStyle(
      backgroundColor: Colors.grey[700],
      decorationColor: Colors.grey[300]),
  'paragraph': const TextStyle(),
};

bool isStyledText(String type) {
  return textStyles.containsKey(type);
}
