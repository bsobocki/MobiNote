import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteImageData extends NoteWidgetData {
  String? path;
  NoteImageData({
    required super.id,
    this.path,
    super.type = 'image',
  });
  
  @override
  String get str => '{$id: image: $path}';
}
