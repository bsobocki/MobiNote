import 'dart:math';
import 'package:mobi_note/backend/text_editor/special_marks_operations/text.dart';

class SpecialPatternInfo {
  final int indexInText;
  final String pattern;

  SpecialPatternInfo({required this.indexInText, required this.pattern});

  @override
  String toString() => "{i: $indexInText, p: $pattern}";
}

class StyledTextConverter {
  List<SpecialPatternInfo> startBounds = [];
  List<SpecialPatternInfo> startTags = [];
  List<String> textBuff = [];
  int startIndex = 0;

  void clearData() {
    startBounds.clear();
    startTags.clear();
    textBuff.clear();
  }

  int startBoundIndex(String char) {
    return startBounds.indexWhere((e) => e.pattern == char);
  }

  void addPlaceholders(int times) {
    for (int i = 1; i <= times; i++) {
      textBuff.add('');
    }
  }

  void addStringToBuff(String text, int startIndex, int length) {
    for (int i = startIndex; i < startIndex + length; i++) {
      textBuff.add(text[i]);
    }
  }

  void convertParagraph(String text) {
    var paragraph = paragraphOf(text, startIndex);
    textBuff.add(unicodeOfParagraphChar(paragraph)!);
    addPlaceholders(paragraph.length - 1);
    startIndex += paragraph.length;
  }

  void convertStyleBoundary(String boundChar, int startBoundIndex) {
    var startBoundIndexInText = startBounds[startBoundIndex].indexInText;
    textBuff[startBoundIndexInText] =
        unicodeOfStyleStartBoundaryChar(boundChar)!;
    textBuff.add(unicodeOfStyleEndBoundaryChar(boundChar)!);
    startBounds = startBounds.sublist(0, startBoundIndex );
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

  String textWithConvertedMarks(String text) {
    if (text.length <= 1) return text;

    clearData();
    startIndex = firstNotWhitespace(text);
    addStringToBuff(text, 0, startIndex);

    if (isParagraphChar(text[startIndex])) {
      convertParagraph(text);
    }

    for (int i = startIndex; i < text.length; i++) {
      var character = text[i];
      if (isStyleBoundaryChar(character)) {
        var context = characterContext(text, i);
        if (matchesStyleEnd(context)) {
          var boundIndex = startBoundIndex(character);
          if (found(boundIndex)) {
            convertStyleBoundary(character, boundIndex);
            continue;
          }
        }
        if (matchesStyleStart(context)) {
          startBounds
              .add(SpecialPatternInfo(indexInText: i, pattern: character));
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
            var tagIndex = startTags.indexWhere((e) => e.pattern == tag);
            if (found(tagIndex)) {
              convertWidgetTags(tag, tagIndex);
              i += tag.length - 1;
              continue;
            } else {
              startTags.add(SpecialPatternInfo(indexInText: i, pattern: tag));
            }
          }
        }
      }
      textBuff.add(character);
    }

    return textBuff.join('');
  }
}

bool found(int index) {
  return index != -1;
}

String firstMatch(String text, int i, Iterable<String> patterns) {
  return patterns.firstWhere(
    (element) => element == text.substring(i, i + element.length),
    orElse: () => '',
  );
}

String characterContext(String text, int i) {
  return text.substring(
    max(0, i - 1),
    min(text.length, i + 2),
  );
}

String getTag(String text, int i) {
  return text.substring(i, min(text.length, i + 3));
}

int firstNotWhitespace(String text) {
  return text.indexOf(RegExp('[^\\s]'));
}

String paragraphOf(String text, int startIndex) {
  int index = startIndex;
  List<String> paragraph = [];
  while (isParagraphChar(text[index])) {
    if ((paragraph += [text[index++]]).length >= 4) break;
  }
  return paragraph.join('');
}
