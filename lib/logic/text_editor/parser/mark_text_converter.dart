import 'package:mobi_note/logic/text_editor/special_marks_operations/text.dart';

import '../../helpers/list_helpers.dart';
import 'mark_text_helpers/paragraph_analyze.dart';

class SpecialPatternInfo {
  final int indexInText;
  final String character;

  SpecialPatternInfo({required this.indexInText, required this.character});

  @override
  String toString() => "{i: $indexInText, p: $character}";
}

class StyledTextConverter {
  String visibleBoundaryChar = '';
  List<SpecialPatternInfo> startBounds = [];
  List<SpecialPatternInfo> startTags = [];
  List<String> textBuff = [];
  int startIndex = 0;

  String textWithConvertedMarks(String text, {int cursorPosition = -1}) {
    if (text.length <= 1) return text;
    if (cursorPosition == -1) cursorPosition = text.length;

    clearData();
    startIndex = firstNonWhitespace(text);
    addStringToBuff(text, 0, startIndex);

    if (!found(startIndex)) {
      return text;
    }

    if (isParagraphChar(text[startIndex])) {
      convertParagraph(text);
    }

    for (int i = startIndex; i < text.length; i++) {
      var character = text[i];

      if (i == cursorPosition && startBounds.isNotEmpty) {
        visibleBoundaryChar = startBounds.last.character;
      }

      if (isStyleBoundaryChar(character)) {
        var context = characterContext(text, i);
        if (matchesStyleBoundaryEnd(context)) {
          var boundIndex = startBoundIndex(character);
          if (found(boundIndex)) {
            convertStyleBoundaryMarks(character, boundIndex);
            continue;
          }
        }
        if (matchesStyleBoundaryBeg(context)) {
          startBounds
              .add(SpecialPatternInfo(indexInText: i, character: character));
        }
      } else {
        var patterns = elementPatternsStartingFrom(character);
        if (patterns.isNotEmpty) {
          var pattern = firstMatch(text, i, patterns);
          if (pattern.isNotEmpty) {
            convertElementPattern(pattern);
            i += pattern.length - 1;
            continue;
          }
        }

        var tags = widgetTagsStartingFrom(character);
        if (tags.isNotEmpty) {
          var tag = firstMatch(text, i, tags);
          if (tag.isNotEmpty) {
            var tagIndex = startTags.indexWhere((e) => e.character == tag);
            if (found(tagIndex)) {
              convertWidgetTags(tag, tagIndex);
              i += tag.length - 1;
              continue;
            } else {
              startTags.add(SpecialPatternInfo(indexInText: i, character: tag));
            }
          }
        }
      }
      textBuff.add(character);
    }

    return textBuff.join('');
  }

  void clearData() {
    startBounds.clear();
    startTags.clear();
    textBuff.clear();
  }

  int startBoundIndex(String char) {
    return startBounds.indexWhere((e) => e.character == char);
  }

  void addPlaceholders(int times) {
    for (int i = 1; i <= times; i++) {
      textBuff.add('\u200B');
    }
  }

  void addChars(String char, int times) {
    for (int i = 1; i <= times; i++) {
      textBuff.add(char);
    }
  }

  void addStringToBuff(String text, int startIndex, int length) {
    for (int i = startIndex; i < startIndex + length; i++) {
      textBuff.add(text[i]);
    }
  }

  void convertParagraph(String text) {
    var paragraph = paragraphOf(text, startIndex);
    var unicode = unicodeOfParagraphChar(paragraph)!;
    addChars(unicode, paragraph.length);
    startIndex += paragraph.length;
  }

  void convertStyleBoundaryMarks(String boundChar, int startBoundIndex) {
    if (boundChar == visibleBoundaryChar) {
      textBuff.add(boundChar);
      startBounds.removeWhere((element) => element.character == boundChar);
    } else {
      var startBoundIndexInText = startBounds[startBoundIndex].indexInText;
      textBuff[startBoundIndexInText] =
          unicodeOfStyleStartBoundaryChar(boundChar)!;
      textBuff.add(unicodeOfStyleEndBoundaryChar(boundChar)!);
      startBounds = startBounds.sublist(0, startBoundIndex);
    }
  }

  void convertElementPattern(String pattern) {
    textBuff.add(unicodeOfElementChar(pattern)!);
    addPlaceholders(pattern.length - 1);
  }

  void convertWidgetTags(String tag, int tagIndex) {
    var startTagIndex = startTags[tagIndex].indexInText;
    textBuff[startTagIndex] = unicodeOfWidgetChar(tag)!;
    for (int j = startTagIndex + 1; j < startTagIndex + tag.length; j++) {
      textBuff[j] = '';
    }
    textBuff.add(unicodeOfWidgetChar(tag)!);
    addPlaceholders(tag.length - 1);
    startTags.removeAt(tagIndex);
  }
}
