import 'package:mobi_note/backend/text_editor/special_marks_operations/text.dart';
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

  test("check text style characters", () {
    expect(isStyleBoundaryChar(' '), false);
    expect(isStyleBoundaryChar('\t'), false);
    expect(isStyleBoundaryChar('\r'), false);
    expect(isStyleBoundaryChar('\u000b'), false);
    expect(isStyleBoundaryChar('\n'), false);
    expect(isStyleBoundaryChar('r'), false);
    expect(isStyleBoundaryChar('a'), false);
    expect(isStyleBoundaryChar('*'), true);
    expect(isStyleBoundaryChar('^'), true);
    expect(isStyleBoundaryChar('_'), true);
    expect(isStyleBoundaryChar('~'), true);
    expect(isStyleBoundaryChar('`'), true);
    expect(isStyleBoundaryChar('\$'), false);
    expect(isParagraphChar('#'), true);
    expect(isParagraphChar('>'), true);
  });

  test("check widgets tags", () {
    expect(widgetTagsStartingFrom('<'), ['<n>']);
    expect(widgetTagsStartingFrom('('), ['(w)', '(n)']);
    expect(widgetTagsStartingFrom('\$'), ['\$']);
    expect(widgetTagsStartingFrom('*'), []);
    expect(widgetTagsStartingFrom('a'), []);
  });

  test("patterns starting from character", () {
    expect(elementPatternsStartingFrom('['), ['[ ]', '[x]', '[i]']);
  });
}
