import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteListData extends NoteWidgetData {
  List<NoteListElementData>? elements;
  NoteListData({
    required super.id,
    this.elements,
    super.type = 'list',
  }) {
    elements ??= [];
  }

  void addElement(NoteListElementData elem) {
    elements!.add(elem);
  }

  bool get isListEmpty => elements!.isEmpty;

  @override
  String get str {
    String s = '{$id: list:\n';
    for (var elem in elements!) {
      s += '${elem.str}\n';
    }
    s += '}';
    return s;
  }
}
