import 'package:mobi_note/backend/text_editor/special_marks_operations/unicode.dart';

int getStyledTextIndexOf(String unicodeMarkedText, int rawTextIndex) {
  int textCharCounter = 0;
  int ind = 0;
  for (ind;
      ind < unicodeMarkedText.length && textCharCounter != rawTextIndex;
      ind++) {
    if (!isSpecialUnicode(unicodeMarkedText[ind])) textCharCounter++;
  }
  return ind;
}

