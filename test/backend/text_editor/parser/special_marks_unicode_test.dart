import 'package:mobi_note/logic/note_editor/text_editor/definitions/unicodes.dart';
import 'package:mobi_note/logic/note_editor/text_editor/special_marks_operations/unicode.dart';
import 'package:test/test.dart';

void main() {
  test("check unicode numbers", () {
    expect(unicodeNumber('\ue340'), 0xe340);
    expect(unicodeNumber('\uefff'), 0xefff);
    expect(unicodeNumber('\ue1a3'), 0xe1a3);
    expect(unicodeNumber('\ue003'), 0xe003);
  });

  test("check unicode in range", () {
    expect(inUnicodeRange(0xe340, styleUnicodeRange), false);
    expect(inUnicodeRange(0xe002, styleUnicodeRange), true);
    expect(inUnicodeRange(0xe003, widgetUnicodeRange), false);
    expect(inUnicodeRange(0xe102, widgetUnicodeRange), true);
    expect(inUnicodeRange(0xe1a5, widgetUnicodeRange), false);
    expect(inUnicodeRange(0xe002, elementPatternUnicodeRange), false);
    expect(inUnicodeRange(0xe1a2, elementPatternUnicodeRange), true);
    expect(inUnicodeRange(0xe201, paragraphStyleUnicodeRange), true);
  });

  test("check unicode characters", () {
    expect(isUnicodeStartSyleCharacter('\ue002'), true);
    expect(isUnicodeStartSyleCharacter('\ue006'), true);
    expect(isUnicodeStartSyleCharacter('\ue008'), true);
    expect(isUnicodeStartSyleCharacter('\ue001'), false);
    expect(isUnicodeStartSyleCharacter('\ue202'), false);
    expect(isUnicodeStartSyleCharacter('\ue1a1'), false);
    expect(isUnicodeStartSyleCharacter('\ue1a2'), false);
    expect(isUnicodeStartSyleCharacter('\ue1a3'), false);
    expect(isUnicodeStartSyleCharacter('\ue004'), true);
    expect(isUnicodeStartSyleCharacter('\ue000'), true);
    expect(isUnicodeStartSyleCharacter('\ue003'), false);
    expect(isUnicodeStartSyleCharacter('\ue302'), false);
    expect(isUnicodeStartSyleCharacter('\ue201'), false);
    expect(isUnicodeStartSyleCharacter('\ue1aa'), false);

    expect(isUnicodeEndStyleCharacter('\ue002'), false);
    expect(isUnicodeEndStyleCharacter('\ue001'), true);
    expect(isUnicodeEndStyleCharacter('\ue202'), false);
    expect(isUnicodeEndStyleCharacter('\ue1a1'), false);
    expect(isUnicodeEndStyleCharacter('\ue1a2'), false);
    expect(isUnicodeEndStyleCharacter('\ue1a3'), false);
    expect(isUnicodeEndStyleCharacter('\ue004'), false);
    expect(isUnicodeEndStyleCharacter('\ue000'), false);
    expect(isUnicodeEndStyleCharacter('\ue003'), true);
    expect(isUnicodeEndStyleCharacter('\ue006'), false);
    expect(isUnicodeEndStyleCharacter('\ue302'), false);
    expect(isUnicodeEndStyleCharacter('\ue201'), false);
    expect(isUnicodeEndStyleCharacter('\ue1aa'), false);

    expect(isUnicodeParagraphStyleCharacter('\ue002'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue001'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue200'), true);
    expect(isUnicodeParagraphStyleCharacter('\ue1a1'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue1a2'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue1a3'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue004'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue000'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue003'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue006'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue302'), false);
    expect(isUnicodeParagraphStyleCharacter('\ue201'), true);
    expect(isUnicodeParagraphStyleCharacter('\ue1aa'), false);

    expect(isUnicodeElementPatternCharacter('\ue002'), false);
    expect(isUnicodeElementPatternCharacter('\ue001'), false);
    expect(isUnicodeElementPatternCharacter('\ue202'), false);
    expect(isUnicodeElementPatternCharacter('\ue1a1'), true);
    expect(isUnicodeElementPatternCharacter('\ue1a2'), true);
    expect(isUnicodeElementPatternCharacter('\ue1a0'), true);
    expect(isUnicodeElementPatternCharacter('\ue004'), false);
    expect(isUnicodeElementPatternCharacter('\ue000'), false);
    expect(isUnicodeElementPatternCharacter('\ue003'), false);
    expect(isUnicodeElementPatternCharacter('\ue006'), false);
    expect(isUnicodeElementPatternCharacter('\ue302'), false);
    expect(isUnicodeElementPatternCharacter('\ue201'), false);
    expect(isUnicodeElementPatternCharacter('\ue1aa'), false);

    expect(isUnicodeWidgetCharacter('\ue002'), false);
    expect(isUnicodeWidgetCharacter('\ue001'), false);
    expect(isUnicodeWidgetCharacter('\ue202'), false);
    expect(isUnicodeWidgetCharacter('\ue1a1'), false);
    expect(isUnicodeWidgetCharacter('\ue1a2'), false);
    expect(isUnicodeWidgetCharacter('\ue1a3'), false);
    expect(isUnicodeWidgetCharacter('\ue004'), false);
    expect(isUnicodeWidgetCharacter('\ue000'), false);
    expect(isUnicodeWidgetCharacter('\ue003'), false);
    expect(isUnicodeWidgetCharacter('\ue006'), false);
    expect(isUnicodeWidgetCharacter('\ue302'), false);
    expect(isUnicodeWidgetCharacter('\ue201'), false);
    expect(isUnicodeWidgetCharacter('\ue1aa'), false);
    expect(isUnicodeWidgetCharacter('\ue101'), true);
    expect(isUnicodeWidgetCharacter('\ue102'), true);
    expect(isUnicodeWidgetCharacter('\ue100'), true);
  });
}
