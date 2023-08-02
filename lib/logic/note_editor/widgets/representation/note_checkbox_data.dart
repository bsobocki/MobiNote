import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteCheckboxData extends NoteWidgetData {
  bool value;

  NoteCheckboxData({
    required super.id,
    this.value = false,
    super.type = 'checkbox',
  });

  NoteCheckboxData.fromJSON(JSON jsonObj)
      : value = jsonObj["value"],
        super.fromJSON(jsonObj);

  @override
  String get str => '{$id: checkbox: $value}';

  @override
  JSON get jsonAdditionalParameters => {"value": value};
}
