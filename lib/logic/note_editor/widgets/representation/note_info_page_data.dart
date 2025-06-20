import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteInfoPageData extends NoteWidgetData {

  NoteInfoPageData({
    required super.id,
    super.type = 'info_page',
  });

  NoteInfoPageData.fromJSON(JSON jsonObj):
        super.fromJSON(jsonObj);

  @override
  String get str => '{$id: info page}';

  @override
  JSON get jsonAdditionalParameters => {};
}
