import 'package:flutter/material.dart';
import 'package:mobi_note/screens/theme/themes.dart';
import '../../constants/text_style_properties.dart';

Map<String, TextStyle> textStyles = {
  'bold': TextStyle(
    fontWeight: FontWeight.bold,
    color: MobiNoteTheme.current.textColor,
  ),
  'italic': TextStyle(
    fontStyle: FontStyle.italic,
    color: MobiNoteTheme.current.textColor,
  ),
  'underline': TextStyle(
    decoration: TextDecoration.underline,
    color: MobiNoteTheme.current.textColor,
  ),
  'strikethrough': TextStyle(
    decoration: TextDecoration.lineThrough,
    color: MobiNoteTheme.current.textColor,
  ),
  'inline_code': TextStyle(
    fontFamily: 'Courier New',
    decorationColor: Colors.black,
    backgroundColor: Colors.grey[300],
    color: Colors.black,
  ),
  'header1': TextStyle(
    fontSize: header1DefaultFontSize,
    fontWeight: FontWeight.w800,
    color: MobiNoteTheme.current.textColor,
  ),
  'header2': TextStyle(
    fontSize: header2DefaultFontSize,
    fontWeight: FontWeight.w800,
    color: MobiNoteTheme.current.textColor,
  ),
  'header3': TextStyle(
    fontSize: header3DefaultFontSize,
    fontWeight: FontWeight.w800,
    color: MobiNoteTheme.current.textColor,
  ),
  'header4': TextStyle(
    fontSize: header4DefaultFontSize,
    fontWeight: FontWeight.w800,
    color: MobiNoteTheme.current.textColor,
  ),
  'quote': TextStyle(
    backgroundColor: Colors.grey[700],
    decorationColor: Colors.grey[300],
  ),
  'paragraph': TextStyle(
    fontSize: paragraphDefaultFontSize,
    color: MobiNoteTheme.current.textColor,
  ),
  'paragraph_chars': TextStyle(color: MobiNoteTheme.current.textColor.withOpacity(0.6)),
  'text_done': const TextStyle(
      decoration: TextDecoration.lineThrough, color: Colors.grey)
};

bool isStyledText(String type) {
  return textStyles.containsKey(type);
}
