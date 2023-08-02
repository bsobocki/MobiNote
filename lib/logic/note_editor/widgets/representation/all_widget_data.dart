import 'note_widget_data.dart';
import 'note_checkbox_data.dart';
import 'note_counter_data.dart';
import 'note_icon_button_data.dart';
import 'note_image_data.dart';
import 'note_info_page_data.dart';
import 'note_label_data.dart';
import 'note_list_data.dart';
import 'note_list_element_data.dart';
import 'note_text_editor_data.dart';

export 'note_widget_data.dart';
export 'note_checkbox_data.dart';
export 'note_counter_data.dart';
export 'note_icon_button_data.dart';
export 'note_image_data.dart';
export 'note_info_page_data.dart';
export 'note_label_data.dart';
export 'note_list_data.dart';
export 'note_list_element_data.dart';
export 'note_text_editor_data.dart';

NoteWidgetData createData(JSON jsonObj) {
  switch (jsonObj["type"]) {
    case "checkbox":
      return NoteCheckboxData.fromJSON(jsonObj);
    case "counter":
      return NoteCounterData.fromJSON(jsonObj);
    case "icon_button":
      return NoteIconButtonData.fromJSON(jsonObj);
    case "image":
      return NoteImageData.fromJSON(jsonObj);
    case "info_page":
      return NoteInfoPageData.fromJSON(jsonObj);
    case "label":
      return NoteLabelData.fromJSON(jsonObj);
    case "list":
      return NoteListData.fromJSON(jsonObj);
    case "list_element":
      return NoteListElementData.fromJSON(jsonObj);
    default:
      return NoteTextEditorData.fromJSON(jsonObj);
  }
}