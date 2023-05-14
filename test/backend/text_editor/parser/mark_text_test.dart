import 'package:mobi_note/backend/text_editor/parser/definitions/marks.dart';
import 'package:mobi_note/backend/text_editor/parser/mark_text.dart';
import 'package:test/test.dart';

void main() {
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
    expect(
      firstMatch(
        "ojj (w) widget appears! and this is <n>",
        36,
        ['[ ]', '[x]', '(a)', '(w)', 'a', '<n>'],
      ),
      '<n>',
    );
    expect(
      firstMatch(
        "ojj (w) widget appears! \$ and this is <n>",
        24,
        widgetTags,
      ),
      '\$',
    );
  });

  test("check getContext", () {
    expect(characterContext('to jest con*text', 11), 'n*t');
    expect(characterContext('to jest con*text', 1), 'to ');
    expect(characterContext('to jest con*text', 7), 't c');
  });

  test("converted style marks", () {
    expect(
      textWithConvertedMarks("this is a *bold ^italic^ text* hihi."),
      "this is a \ue000bold \ue002italic\ue003 text\ue001 hihi.",
    );
    expect(
      textWithConvertedMarks(
          "#paragraph ; *and* _this `is`_ *a \$not *bold * ~strikethrough~ text\$>quote ~ hihihihi.~%"),
      "\ue200paragraph ; \ue000and\ue001 \ue004this \ue008is\ue009\ue005 *a \ue103not *bold * \ue006strikethrough\ue007 text\ue103>quote ~ hihihihi.~%",
    );
    expect(
      textWithConvertedMarks(
        "> This is quoted text, did you know?",
      ),
      "\ue201 This is quoted text, did you know?"
    );
    expect(
      textWithConvertedMarks(
        "% And this is LaTeX",
      ),
      "\ue202 And this is LaTeX"
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
