import 'package:mobi_note/logic/text_editor/parser/definitions/span_info.dart';
import 'package:mobi_note/logic/text_editor/parser/unicode_marked_text_parser.dart';
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
        "  Piszę sobie boldem i boldem italic strike i underline tak o a to widget .";
    SpanInfo expectedParagraph =
        SpanInfo(type: 'paragraph', text: "  Piszę sobie ");
    expectedParagraph.parent = expectedParagraph;
    createChildSpanInfo(expectedParagraph, 'bold', "\u200Bbold\u200B");
    createChildSpanInfo(expectedParagraph, 'text', "em i ");
    var bold = createChildSpanInfo(expectedParagraph, 'bold', "\u200Bboldem \u200B");
    var italic = createChildSpanInfo(bold, 'italic', "\u200Bitalic \u200B");
    createChildSpanInfo(italic, 'strikethrough', "\u200Bstrike\u200B");
    createChildSpanInfo(italic, 'text', " i ");
    createChildSpanInfo(italic, 'underline', "\u200Bunderline\u200B");
    createChildSpanInfo(expectedParagraph, 'text', " tak o a to widget ");
    createChildSpanInfo(expectedParagraph, 'note_widget', "\u200Bwidget:taki\u200B");
    createChildSpanInfo(expectedParagraph, 'text', ".");

    UnicodeMarkedTextParser parser = UnicodeMarkedTextParser();
    var result = parser.parseUnicodeMarkedText(text);

    expect(result.rawText, expectedRawText);
    expect(result.spanInfo.str, expectedParagraph.str);
  });
}
