import 'package:mobi_note/backend/text_editor/parser/definitions/types/style_types.dart';
import 'package:mobi_note/backend/text_editor/parser/definitions/unicodes.dart';
import 'package:mobi_note/backend/text_editor/parser/special_marks_operations/unicode.dart';
import 'widget_types.dart';
import 'element_types.dart';
import 'paragraph_types.dart';

String decodeStyleType(String unicode) {
  int index = (unicodeNumber(unicode) - styleUnicodeNumber) ~/ 2;
  return styleTypes[index];
}

String decodeWidgetType(String unicode) {
  int index = unicodeNumber(unicode) - widgetUnicodeNumber;
  return widgetTypes[index];
}

String decodeElementType(String unicode) {
  int index = unicodeNumber(unicode) - elementUnicodeNumber;
  return elementTypes[index];
}

String decodeParagraphType(String unicode) {
  int index = unicodeNumber(unicode) - paragraphUnicodeNumber;
  return paragraphTypes[index];
}