import 'note_checkbox_data.dart';
import 'note_counter_data.dart';
import 'note_info_page_data.dart';
import 'note_text_editor_data.dart';
import 'note_widget_data.dart';

enum ElementType { checkbox, number, marks, counter, custom }

class NoteListElementData extends NoteWidgetData {
  int depth;
  ElementType elemType;
  NoteCheckboxData? checkboxData;
  NoteTextEditorData? textEditorData;
  NoteCounterData? counterData;
  NoteInfoPageData? infoPageData;

  NoteListElementData({
    required super.id,
    required this.depth,
    required this.elemType,
    this.checkboxData,
    this.textEditorData,
    this.counterData,
    this.infoPageData,
    super.type = 'list_element',
  }) {
    if (elemType == ElementType.checkbox) {
      checkboxData ??= NoteCheckboxData(id: -1);
    }
    textEditorData ??= NoteTextEditorData(id: id, text: '');
  }

  String getStrIfNotNull(NoteWidgetData? data) {
    if (data != null) {
      return data.str;
    }
    return '';
  }

  @override
  String get str {
    String s = '${'  ' * (depth + 1)}{$id: elem: ';
    s += getStrIfNotNull(checkboxData);
    s += getStrIfNotNull(textEditorData);
    s += getStrIfNotNull(counterData);
    s += getStrIfNotNull(infoPageData);
    return '$s }';
  }
}
