import 'dart:math';
import 'package:mobi_note/backend/text_editor/parser/special_marks_operations/text.dart';

class SpecialPatternInfo {
  final int indexInText;
  final String pattern;

  SpecialPatternInfo({required this.indexInText, required this.pattern});
}

class StyledTextConverter {
  List<SpecialPatternInfo> startBounds = [];
  List<SpecialPatternInfo> startTags = [];
  List<String> textBuff = [];

  int startBoundIndex(String char) {
    return startBounds.indexWhere((e) => e.pattern == char);
  }

  void convertStyleBoundary(String boundChar, int startBoundIndex) {
    var startBoundIndexInText = startBounds[startBoundIndex].indexInText;
    textBuff[startBoundIndexInText] =
        unicodeOfStyleStartBoundaryChar(boundChar)!;
    textBuff.add(unicodeOfStyleEndBoundaryChar(boundChar)!);
    startBounds.removeAt(startBoundIndex);
  }

  void convertElementPattern(String pattern) {
    textBuff.add(unicodeOfElementChar(pattern)!);
    for (int j = 1; j < pattern.length; j++) {
      textBuff.add('');
    }
  }

  void convertWidgetTags(String tag, int tagIndex) {
    var startTagIndex = startTags[tagIndex].indexInText;
    textBuff[startTagIndex] = unicodeOfWidgetChar(tag)!;
    for (int j = startTagIndex + 1; j < startTagIndex + tag.length; j++) {
      textBuff[j] = '';
    }
    textBuff.add(unicodeOfWidgetChar(tag)!);
    for (int j = 1; j < tag.length; j++) {
      textBuff.add('');
    }
    startTags.removeAt(tagIndex);
  }

  String textWithConvertedMarks(String text) {
    textBuff.clear();
    int startIndex = 0;

    if (isParagraphChar(text[0])) {
      textBuff.add(unicodeOfParagraphChar(text[0])!);
      startIndex = 1;
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
