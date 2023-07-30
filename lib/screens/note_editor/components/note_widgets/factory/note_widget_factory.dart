import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_checkbox_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_counter_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_icon_button_widget.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_image_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_text_editor_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_counter_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_icon_button_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_list_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_list_element_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_checkbox_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_image_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_text_editor_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteEditorWidgetFactory {
  final int startId;
  Map<String, IdGenerator> idGenerator = {};
  NoteEditorWidgetFactory({this.startId = 0});

  NoteEditorWidget create(NoteWidgetData data) {
    int id = nextId(data.type);
    switch (data.type) {
      case 'image':
        return NoteImageWidget(
          id: id,
          data: data as NoteImageData,
        );
      case 'checkbox':
        return NoteCheckboxWidget(
          id: id,
          data: data as NoteCheckboxData,
        );
      case 'list_element':
        return NoteListElementWidget(
          id: id,
          data: data as NoteListElementData,
          widgetFactory: this,
        );
      case 'list':
        return NoteListWidget(
          id: id,
          data: data as NoteListData,
          widgetFactory: this,
        );
      case 'counter':
        return NoteCounterWidget(
          id: id,
          data: data as NoteCounterData,
        );
      case 'icon_button':
        return NoteIconButtonWidget(
          id: id,
          data: data as NoteIconButtonData,
        );
      default:
        return NoteTextEditorWidget(
          id: id,
          data: data as NoteTextEditorData,
        );
    }
  }

  int nextId(String type) {
    if (!idGenerator.keys.contains(type)) {
      idGenerator[type] = IdGenerator();
    }
    return idGenerator[type]!.nextId;
  }
}
