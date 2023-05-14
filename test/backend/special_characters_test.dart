import 'package:flutter/widgets.dart';
import 'package:mobi_note/backend/text_editor/parser/mark_text.dart';
import 'package:mobi_note/backend/text_editor/parser/parse.dart';
import 'package:mobi_note/backend/text_editor/parser/special_marks/definitions/unicodes.dart';
import 'package:mobi_note/backend/text_editor/parser/special_marks/plain_text.dart';
import 'package:mobi_note/backend/text_editor/parser/special_marks/unicode.dart';
import 'package:test/test.dart';

void main() {
  test(
      "check context of middle character to determine whether it is a style end or not",
      () {
    expect(matchesStyleEnd(" *c"), false);
    expect(matchesStyleEnd("d*c"), true);
    expect(matchesStyleEnd(" *^"), false);
    expect(matchesStyleEnd(" **"), false);
    expect(matchesStyleEnd("***"), true);
    expect(matchesStyleEnd("c* "), true);
    expect(matchesStyleEnd(" * "), false);
    expect(matchesStyleEnd("a~ "), true);
    expect(matchesStyleEnd("_^ "), true);
  });

  test(
      "check context of middle character to determine whether it is a new style start or not",
      () {
    expect(matchesStyleStart(" *c"), true);
    expect(matchesStyleStart("d*c"), true);
    expect(matchesStyleStart(" *^"), true);
    expect(matchesStyleStart(" *~"), true);
    expect(matchesStyleStart(" **"), true);
    expect(matchesStyleStart("***"), true);
  });

  test("check whitespaces", () {
    expect(isWhitespace(' '), true);
    expect(isWhitespace('\t'), true);
    expect(isWhitespace('\r'), true);
    expect(isWhitespace('\u000b'), true);
    expect(isWhitespace('\n'), true);
    expect(isWhitespace('r'), false);
    expect(isWhitespace('*'), false);
    expect(isWhitespace('^'), false);
  });

  test("check style characters", () {
    expect(isStyleBoundaryCharacter(' '), false);
    expect(isStyleBoundaryCharacter('\t'), false);
    expect(isStyleBoundaryCharacter('\r'), false);
    expect(isStyleBoundaryCharacter('\u000b'), false);
    expect(isStyleBoundaryCharacter('\n'), false);
    expect(isStyleBoundaryCharacter('r'), false);
    expect(isStyleBoundaryCharacter('a'), false);
    expect(isStyleBoundaryCharacter('*'), true);
    expect(isStyleBoundaryCharacter('^'), true);
    expect(isStyleBoundaryCharacter('_'), true);
    expect(isStyleBoundaryCharacter('~'), true);
    expect(isStyleBoundaryCharacter('`'), true);
    expect(isStyleBoundaryCharacter('\$'), true);

    expect(isOneCharStyleMarkCharacter('#'), true);
    expect(isOneCharStyleMarkCharacter('>'), true);
  });

  test("patterns starting from character", () {
    expect(elementPatternsStartingFrom('['), ['[ ]', '[x]', '[i]']);
  });

  test("first match from list to text", () {
    expect(
      firstMatch(
        "this is a [ ] unselected checkbox and this is [x] checked.",
        10,
        ['[ ]', '[x]', '[i]'],
      ),
      '[ ]',
    );
    expect(
      firstMatch(
        "ojj (w) widget appears! and this is (w)",
        4,
        ['[ ]', '[x]', '(a)', '(w)', 'a', ' '],
      ),
      '(w)',
    );
  });

  test("check getContext", () {
    expect(getCharacterContext('to jest con*text', 11), 'n*t');
    expect(getCharacterContext('to jest con*text', 1), 'to ');
    expect(getCharacterContext('to jest con*text', 7), 't c');
  });

  test("converted style marks", () {
    expect(
      textWithConvertedMarks("this is a *bold ^italic^ text* hihi."),
      "this is a \ue000bold \ue002italic\ue003 text\ue001 hihi.",
    );
    expect(
      textWithConvertedMarks(
          "#paragraph ; *and* _this `is`_ *a \$not *bold * ~strikethrough~ text\$>quote ~ hihihihi.~"),
      "\ue200paragraph ; \ue000and\ue001 \ue004this \ue008is\ue009\ue005 *a \ue00anot *bold * \ue006strikethrough\ue007 text\ue00b\ue201quote ~ hihihihi.~",
    );
  });

  test("converted elements and widgets", () {
    expect(
      textWithConvertedMarks(
          "this is a [ ] unselected checkbox and this is [x] checked."),
      "this is a \ue1a0 unselected checkbox and this is \ue1a1 checked.",
    );
    expect(
      textWithConvertedMarks(
          "(n)this is(n) a (w)[ ] widget(w) and next (w) to(n) it is unselected checkbox and this is [x] selected checkbox[i] and this is nothing (i), [v] and [ x] or [x ] hihi<n>.<n>"),
      "\ue101this is\ue101 a \ue100\ue1a0 widget\ue100 and next (w) to(n) it is unselected checkbox and this is \ue1a1 selected checkbox\ue1a2 and this is nothing (i), [v] and [ x] or [x ] hihi\ue102.\ue102",
    );
  });

  test("check unicode numbers", () {
    expect(unicodeNumber('\ue340'), 0xe340);
    expect(unicodeNumber('\uefff'), 0xefff);
    expect(unicodeNumber('\ue1a3'), 0xe1a3);
    expect(unicodeNumber('\ue003'), 0xe003);
  });

  test("check unicode in range", () {
    expect(inUnicodeRange(0xe340, styleUnicodeRange), false);
    expect(inUnicodeRange(0xe002, styleUnicodeRange), true);
    expect(inUnicodeRange(0xe003, widgetUnicodeRange), false);
    expect(inUnicodeRange(0xe102, widgetUnicodeRange), true);
    expect(inUnicodeRange(0xe1a5, widgetUnicodeRange), false);
    expect(inUnicodeRange(0xe002, elementPatternUnicodeRange), false);
    expect(inUnicodeRange(0xe1a2, elementPatternUnicodeRange), true);
    expect(inUnicodeRange(0xe201, oneCharStyleUnicodeRange), true);
  });

  test("check unicode characters", () {
    expect(isUnicodeStartSyleCharacter('\ue002'), true);
    expect(isUnicodeStartSyleCharacter('\ue001'), false);
    expect(isUnicodeStartSyleCharacter('\ue202'), false);
    expect(isUnicodeStartSyleCharacter('\ue1a1'), false);
    expect(isUnicodeStartSyleCharacter('\ue1a2'), false);
    expect(isUnicodeStartSyleCharacter('\ue1a3'), false);
    expect(isUnicodeStartSyleCharacter('\ue004'), true);
    expect(isUnicodeStartSyleCharacter('\ue000'), true);
    expect(isUnicodeStartSyleCharacter('\ue003'), false);
    expect(isUnicodeStartSyleCharacter('\ue302'), false);
    expect(isUnicodeStartSyleCharacter('\ue201'), false);
    expect(isUnicodeStartSyleCharacter('\ue1aa'), false);

    
    expect(isUnicodeEndStyleCharacter('\ue002'), false);
    expect(isUnicodeEndStyleCharacter('\ue001'), true);
    expect(isUnicodeEndStyleCharacter('\ue202'), false);
    expect(isUnicodeEndStyleCharacter('\ue1a1'), false);
    expect(isUnicodeEndStyleCharacter('\ue1a2'), false);
    expect(isUnicodeEndStyleCharacter('\ue1a3'), false);
    expect(isUnicodeEndStyleCharacter('\ue004'), false);
    expect(isUnicodeEndStyleCharacter('\ue000'), false);
    expect(isUnicodeEndStyleCharacter('\ue003'), true);
    expect(isUnicodeEndStyleCharacter('\ue006'), false);
    expect(isUnicodeEndStyleCharacter('\ue302'), false);
    expect(isUnicodeEndStyleCharacter('\ue201'), false);
    expect(isUnicodeEndStyleCharacter('\ue1aa'), false);

    
    expect(isUnicodeOneCharStyleMarkCharacter('\ue002'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue001'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue200'), true);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue1a1'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue1a2'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue1a3'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue004'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue000'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue003'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue006'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue302'), false);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue201'), true);
    expect(isUnicodeOneCharStyleMarkCharacter('\ue1aa'), false);

    
    expect(isUnicodeElementPatternCharacter('\ue002'), false);
    expect(isUnicodeElementPatternCharacter('\ue001'), false);
    expect(isUnicodeElementPatternCharacter('\ue202'), false);
    expect(isUnicodeElementPatternCharacter('\ue1a1'), true);
    expect(isUnicodeElementPatternCharacter('\ue1a2'), true);
    expect(isUnicodeElementPatternCharacter('\ue1a0'), true);
    expect(isUnicodeElementPatternCharacter('\ue004'), false);
    expect(isUnicodeElementPatternCharacter('\ue000'), false);
    expect(isUnicodeElementPatternCharacter('\ue003'), false);
    expect(isUnicodeElementPatternCharacter('\ue006'), false);
    expect(isUnicodeElementPatternCharacter('\ue302'), false);
    expect(isUnicodeElementPatternCharacter('\ue201'), false);
    expect(isUnicodeElementPatternCharacter('\ue1aa'), false);
    
    expect(isUnicodeWidgetCharacter('\ue002'), false);
    expect(isUnicodeWidgetCharacter('\ue001'), false);
    expect(isUnicodeWidgetCharacter('\ue202'), false);
    expect(isUnicodeWidgetCharacter('\ue1a1'), false);
    expect(isUnicodeWidgetCharacter('\ue1a2'), false);
    expect(isUnicodeWidgetCharacter('\ue1a3'), false);
    expect(isUnicodeWidgetCharacter('\ue004'), false);
    expect(isUnicodeWidgetCharacter('\ue000'), false);
    expect(isUnicodeWidgetCharacter('\ue003'), false);
    expect(isUnicodeWidgetCharacter('\ue006'), false);
    expect(isUnicodeWidgetCharacter('\ue302'), false);
    expect(isUnicodeWidgetCharacter('\ue201'), false);
    expect(isUnicodeWidgetCharacter('\ue1aa'), false);
    expect(isUnicodeWidgetCharacter('\ue101'), true);
    expect(isUnicodeWidgetCharacter('\ue102'), true);
    expect(isUnicodeWidgetCharacter('\ue100'), true);
  });
}
