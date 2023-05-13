import 'dart:math';
import 'package:mobi_note/backend/text_editor/parser/special_characters.dart';

class SpecialPatternInfo {
  final int indexInText;
  final String pattern;

  SpecialPatternInfo({required this.indexInText, required this.pattern});
}

String textWithConvertedMarks(String text) {
  List<String> textBuff = [];
  List<SpecialPatternInfo> startBounds = [];
  List<SpecialPatternInfo> startTags = [];

  for (int i = 0; i < text.length; i++) {
    var character = text[i];
    if (isOneCharStyleMarkCharacter(character)) {
      textBuff.add(oneCharStyleMarkConversion[character]!);
      continue;
    } else if (isStyleBoundaryCharacter(character)) {
      var context = getCharacterContext(text, i);
      if (matchesStyleEnd(context)) {
        var boundIndex = startBounds.indexWhere((e) => e.pattern == character);
        if (found(boundIndex)) {
          var startBoundIndex = startBounds[boundIndex].indexInText;
          textBuff[startBoundIndex] = startStyleCharConversion[character]!;
          textBuff.add(endStyleCharConversion[character]!);
          startBounds.removeAt(boundIndex);
          continue;
        }
      }
      if (matchesStyleStart(context)) {
        startBounds.add(SpecialPatternInfo(indexInText: i, pattern: character));
      }
    } else {
      var patterns = elementPatternsStartingFrom(character);
      if (patterns.isNotEmpty) {
        var pattern = firstMatch(text, i, patterns);
        if (pattern.isNotEmpty) {
          textBuff.add(elementPatternsConversion[pattern]!);
          for (int j = 1; j < pattern.length; j++) {
            textBuff.add('');
          }
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
            var startTagIndex = startTags[tagIndex].indexInText;
            textBuff[startTagIndex] = widgetTagConversion[tag]!;
            for (int j = startTagIndex + 1;
                j < startTagIndex + tag.length;
                j++) {
              textBuff[j] = '';
            }
            textBuff.add(widgetTagConversion[tag]!);
            for (int j = 1; j < tag.length; j++) {
              textBuff.add('');
            }
            i += tag.length - 1;
            startTags.removeAt(tagIndex);
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

bool found(int index) {
  return index != -1;
}

String firstMatch(String text, int i, Iterable<String> patterns) {
  return patterns.firstWhere(
    (element) => element == text.substring(i, i + element.length),
    orElse: () => '',
  );
}

String getCharacterContext(String text, int i) {
  return text.substring(
    max(0, i - 1),
    min(text.length, i + 2),
  );
}

String getTag(String text, int i) {
  return text.substring(i, min(text.length, i + 3));
}
