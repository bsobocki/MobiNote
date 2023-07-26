import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteTextEditorData extends NoteWidgetData {
  String text;

  NoteTextEditorData({
    required super.id,
    this.text = '',
    super.type = 'text_editor',
  });

  @override
  String get str => '{$id : text: $text}';
}
