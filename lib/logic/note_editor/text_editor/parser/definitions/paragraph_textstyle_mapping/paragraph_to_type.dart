import '../marks.dart';
import '../types/text_types.dart';

String paragraphCharsToType(String paragraphChars) {
  var index = paragraphStyleChars.indexOf(paragraphChars);
  return index == -1 ? 'paragraph' : paragraphTypes[index];
}
