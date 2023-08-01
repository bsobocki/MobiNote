import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteCounterData extends NoteWidgetData {
  int target;
  int count;
  NoteCounterData({
    required super.id,
    required this.target,
    this.count = 0,
    super.type = 'counter',
  });

  @override
  String get str => '{$id: counter: $count}';

  @override
  JSON get jsonAdditionalParameters => {"target": target, "count": count};
}
