import 'package:mobi_note/backend/text_editing/style/special_characters.dart';
import 'package:test/test.dart';

void main() {
  test("check context of middle character to determine whether it is a closure or not", () {
    expect(isClosure(" *c"), true);
    expect(isClosure("d*c"), false);
    expect(isClosure(" *^"), true);
    expect(isClosure(" *~"), true);
    expect(isClosure(" **"), true);
    expect(isClosure("***"), false);
  });
}
