import 'package:mobi_note/backend/text_editor/parser/definitions/span_info.dart';
import 'package:mobi_note/backend/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:test/test.dart';

SpanInfo createChildSpanInfo(SpanInfo span, String type, String text) {
  SpanInfo child = SpanInfo(type: type, text: text);
  child.parent = span;
  span.children += [child];
  return child;
}

void main() {
  test("parse unicode marked text into span info structure", () {
    String text =
        "  Piszę sobie \ue000bold\ue001em i \ue000boldem \ue002italic \ue006strike\ue007 i \ue004underline\ue005\ue003\ue001 tak o a to widget \ue102widget:taki\ue102.";
    String expectedRawText =
        "  Piszę sobie \u2009bold\u2009em i \u2009boldem \u2009italic \u2009strike\u2009 i \u2009underline\u2009\u2009\u2009 tak o a to widget \u2009.";
    SpanInfo expectedParagraph =
        SpanInfo(type: 'paragraph', text: "  Piszę sobie ");
    expectedParagraph.parent = expectedParagraph;
    createChildSpanInfo(expectedParagraph, 'bold', "bold");
    createChildSpanInfo(expectedParagraph, 'text', "em i ");
    var bold = createChildSpanInfo(expectedParagraph, 'bold', "boldem ");
    var italic = createChildSpanInfo(bold, 'italic', "italic ");
    createChildSpanInfo(italic, 'strikethrough', "strike");
    createChildSpanInfo(italic, 'text', " i ");
    createChildSpanInfo(italic, 'underline', "underline");
    createChildSpanInfo(expectedParagraph, 'text', " tak o a to widget ");
    createChildSpanInfo(expectedParagraph, 'note_widget', "widget:taki");
    createChildSpanInfo(expectedParagraph, 'text', ".");

    UnicodeMarkedTextParser parser = UnicodeMarkedTextParser();
    var result = parser.parseUnicodeMarkedText(text);

    expect(result.rawText == expectedRawText, true);
    expect(result.spanInfo.str == expectedParagraph.str, true);
  });
}
