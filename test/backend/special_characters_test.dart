import 'package:mobi_note/backend/text_editing/style/special_characters.dart';
import 'package:test/test.dart';

void main() {
  test("check context of middle character to determine whether it is a closure or not", () {
    expect(isClosure(" *c"), false);
    expect(isClosure("d*c"), false);
    expect(isClosure(" *^"), false);
    expect(isClosure(" **"), false);
    expect(isClosure("***"), false);
    expect(isClosure("c* "), true);
    expect(isClosure(" * "), false);
    expect(isClosure("a~ "), true);
    expect(isClosure("_^ "), true);
  });

  test("check context of middle character to determine whether it is an opening or not", () {
    expect(isOpening(" *c"), true);
    expect(isOpening("d*c"), false);
    expect(isOpening(" *^"), true);
    expect(isOpening(" *~"), true);
    expect(isOpening(" **"), true);
    expect(isOpening("***"), false);
  });

  test("check context of middle character to determine whether it is an middle or not", () {
    expect(isMiddle(" *c"), false);
    expect(isMiddle("d*c"), true);
    expect(isMiddle(" *^"), false);
    expect(isMiddle(" *~"), false);
    expect(isMiddle(" **"), false);
    expect(isMiddle("***"), true);
    expect(isMiddle("n*^"), true);
    expect(isMiddle("_**"), true);
    expect(isMiddle("g*g"), true);
  });
}
