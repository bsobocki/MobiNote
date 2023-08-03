import 'package:mobi_note/logic/note_editor/text_editor/definitions/types/text_types.dart';
import 'package:mobi_note/logic/note_editor/text_editor/definitions/unicodes.dart';
import 'package:mobi_note/logic/note_editor/text_editor/special_marks_operations/unicode.dart';
import '../../definitions/marks.dart';
import '../../definitions/types/widget_types.dart';
import '../../definitions/types/element_types.dart';

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

String decodeParagraphStyleChars(String unicode) {
  int index = unicodeNumber(unicode) - paragraphUnicodeNumber;
  return paragraphStyleChars[index];
}