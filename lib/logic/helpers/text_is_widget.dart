import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';

bool isWidget(String text) {
  return text.length >= 3 && text.substring(0, 3) == '!$placeholder:';
}