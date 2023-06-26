import 'package:flutter/material.dart';
import '../constants/text_style_properties.dart';

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
    fontSize: header1DefaultFontSize,
  ),
  'header2': const TextStyle(
    fontSize: header2DefaultFontSize,
  ),
  'header3': const TextStyle(
    fontSize: header3DefaultFontSize,
  ),
  'header4': const TextStyle(
    fontSize: header4DefaultFontSize,
  ),
  'quote': TextStyle(
      backgroundColor: Colors.grey[700],
      decorationColor: Colors.grey[300]),
  'paragraph': const TextStyle(
    fontSize: paragraphDefaultFontSize
  ),
};

bool isStyledText(String type) {
  return textStyles.containsKey(type);
}
