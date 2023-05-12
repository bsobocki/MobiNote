import 'package:mobi_note/backend/text_editing/style/special_characters.dart';
import 'package:test/test.dart';

void main() {
  test("check if context is a closure", () {
    expect(isClosure(" *c"), true);
    expect(isClosure("d*c"), false);
  });
}
