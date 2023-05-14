import 'package:mobi_note/backend/text_editor/parser/special_marks_operations/text.dart';
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
    expect(isStyleBoundaryCharacter('\$'), false);
    expect(isParagraphStyleCharacter('#'), true);
    expect(isParagraphStyleCharacter('>'), true);
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
