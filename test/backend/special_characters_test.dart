import 'package:flutter/widgets.dart';
import 'package:mobi_note/backend/text_editor/parse.dart';
import 'package:mobi_note/backend/text_editor/style/special_characters.dart';
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

  test("check style boundary characters", () {
    expect(isStyleBoundaryCharacter(' '), false);
    expect(isStyleBoundaryCharacter('\t'), false);
    expect(isStyleBoundaryCharacter('\r'), false);
    expect(isStyleBoundaryCharacter('\u000b'), false);
    expect(isStyleBoundaryCharacter('\n'), false);
    expect(isStyleBoundaryCharacter('r'), false);
    expect(isStyleBoundaryCharacter('a'), false);
    expect(isStyleBoundaryCharacter('*'), true);
    expect(isStyleBoundaryCharacter('^'), true);
    expect(isStyleBoundaryCharacter('#'), true);
    expect(isStyleBoundaryCharacter('_'), true);
    expect(isStyleBoundaryCharacter('~'), true);
    expect(isStyleBoundaryCharacter('`'), true);
    expect(isStyleBoundaryCharacter('\$'), true);
  });

  test("patterns starting from character", () {
    expect(elementPatternsStartingFrom('['), ['[ ]', '[x]', '[i]']);
  });

  test("first match from list to text", () {
    expect(
      firstMatch(
        "this is a [ ] unselected checkbox and this is [x] checked.",
        10,
        ['[ ]', '[x]','[i]'],
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
    expect(getContext('to jest con*text', 11), 'n*t');
    expect(getContext('to jest con*text', 1), 'to ');
    expect(getContext('to jest con*text', 7), 't c');
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
}
