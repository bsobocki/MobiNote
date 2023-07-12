import 'package:mobi_note/logic/note_editor/text_editor/special_marks_operations/unicode.dart';

int getStyledTextIndexOf(String unicodeMarkedText, int rawTextIndex) {
  int textCharCounter = 0;
  int ind = 0;
  int jumpedChars = 0;
  for (ind;
      ind < unicodeMarkedText.length && textCharCounter != rawTextIndex;
      ind++) {
    if (!isSpecialUnicode(unicodeMarkedText[ind])) {
      textCharCounter++;
    } else if (isUnicodeElementPatternCharacter(unicodeMarkedText[ind])) {
      jumpedChars += 2;
    }
    else if (isUnicodeWidgetCharacter(unicodeMarkedText[ind])) {
      
    }
  }
  return ind + jumpedChars;
}
