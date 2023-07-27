import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteCounterData extends NoteWidgetData {
  int targetValue;
  int count;
  NoteCounterData({
    required super.id,
    required this.targetValue,
    this.count = 0,
    super.type = 'counter',
  });

  @override
  String get str => '{$id: counter: $count}';
}
