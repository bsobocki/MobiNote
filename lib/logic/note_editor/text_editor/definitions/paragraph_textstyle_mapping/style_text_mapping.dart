import 'package:flutter/material.dart';
import 'package:mobi_note/screens/theme/themes.dart';
import '../../constants/text_style_properties.dart';

TextStyle textStyle(String style) {
  switch (style) {
    case 'bold':
      return TextStyle(
        fontWeight: FontWeight.bold,
        color: MobiNoteTheme.current.textColor,
      );
    case 'italic':
      return TextStyle(
        fontStyle: FontStyle.italic,
        color: MobiNoteTheme.current.textColor,
      );
    case 'underline':
      return TextStyle(
        decoration: TextDecoration.underline,
        color: MobiNoteTheme.current.textColor,
      );
    case 'strikethrough':
      return TextStyle(
        decoration: TextDecoration.lineThrough,
        color: MobiNoteTheme.current.textColor,
      );
    case 'inline_code':
      return TextStyle(
        fontFamily: 'Courier New',
        decorationColor: Colors.black,
        backgroundColor: Colors.grey[300],
        color: Colors.black,
      );
    case 'header1':
      return TextStyle(
        fontSize: header1DefaultFontSize,
        fontWeight: FontWeight.w800,
        color: MobiNoteTheme.current.textColor,
      );
    case 'header2':
      return TextStyle(
        fontSize: header2DefaultFontSize,
        fontWeight: FontWeight.w800,
        color: MobiNoteTheme.current.textColor,
      );
    case 'header3':
      return TextStyle(
        fontSize: header3DefaultFontSize,
        fontWeight: FontWeight.w800,
        color: MobiNoteTheme.current.textColor,
      );
    case 'header4':
      return TextStyle(
        fontSize: header4DefaultFontSize,
        fontWeight: FontWeight.w800,
        color: MobiNoteTheme.current.textColor,
      );
    case 'quote':
      return TextStyle(
        backgroundColor: Colors.grey[700],
        decorationColor: Colors.grey[300],
      );
    case 'paragraph_chars':
      return TextStyle(color: MobiNoteTheme.current.textColor.withOpacity(0.6));
    case 'text_done':
      return const TextStyle(
          decoration: TextDecoration.lineThrough, color: Colors.grey);
    case 'paragraph':
    default:
      return TextStyle(
        fontSize: paragraphDefaultFontSize,
        color: MobiNoteTheme.current.textColor,
      );
  }
}
