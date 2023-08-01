import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteLabelData extends NoteWidgetData {
  String label;
  NoteLabelData({
    required super.id,
    required this.label,
    super.type = 'label',
  });

  @override
  String get str => '{$id: label: $label}';

  @override
  JSON get jsonAdditionalParameters => {"label": label};
}
