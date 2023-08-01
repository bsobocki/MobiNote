import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteImageData extends NoteWidgetData {
  String? path;
  double width;
  double height;
  NoteImageData({
    required super.id,
    this.path,
    this.width = -1.0,
    this.height = -1.0,
    super.type = 'image',
  });

  @override
  String get str => '{$id: image: $path}';

  @override
  JSON get jsonAdditionalParameters => {
        "path": path,
        "width": width,
        "height": height,
      };
}
