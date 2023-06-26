import 'package:mobi_note/logic/text_editor/parser/definitions/types/decode.dart';
import 'package:test/test.dart';

void main() {
  test('decode style', () {
    expect(decodeStyleType('\ue000'), 'bold');
    expect(decodeStyleType('\ue001'), 'bold');
    expect(decodeStyleType('\ue002'), 'italic');
    expect(decodeStyleType('\ue003'), 'italic');
    expect(decodeStyleType('\ue004'), 'underline');
    expect(decodeStyleType('\ue005'), 'underline');
    expect(decodeStyleType('\ue006'), 'strikethrough');
    expect(decodeStyleType('\ue007'), 'strikethrough');
    expect(decodeStyleType('\ue008'), 'inline_code');
    expect(decodeStyleType('\ue009'), 'inline_code');
  });
  
  test('decode widgets', () {
    expect(decodeWidgetType('\ue100'), 'web_link');
    expect(decodeWidgetType('\ue101'), 'note_link');
    expect(decodeWidgetType('\ue102'), 'note_widget');
    expect(decodeWidgetType('\ue103'), 'inline_latex');
  });
  
  test('decode elements', () {
    expect(decodeElementType('\ue1a0'), 'unselected_checkbox');
    expect(decodeElementType('\ue1a1'), 'selected_checkbox');
    expect(decodeElementType('\ue1a2'), 'image');
  });
  
  test('decode paragraphs', () {
    expect(decodeParagraphType('\ue200'), 'header1');
    expect(decodeParagraphType('\ue201'), 'header2');
    expect(decodeParagraphType('\ue202'), 'header3');
    expect(decodeParagraphType('\ue203'), 'header4');
    expect(decodeParagraphType('\ue204'), 'quote');
    expect(decodeParagraphType('\ue205'), 'latex');
  });
}
