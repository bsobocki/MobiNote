import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/screens/note_editor/components/note_list/list.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_checkbox_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_image_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/note_editor/helpers/images.dart';

class NoteEditorWidgetFactory {
  final int startId;
  late IdGenerator stateIdGenerator;
  NoteEditorWidgetFactory({this.startId = 0}) {
    stateIdGenerator = IdGenerator(currId: startId);
  }

  Future<NoteEditorWidget> create(String type) async {
    int id = stateIdGenerator.nextId;
    switch (type) {
      case 'image':
        String path = await chooseImage();
        return NoteImageWidget(path: path, id: id);
      case 'checkbox':
        return NoteCheckboxWidget(id: id);
      default:
        return NoteListWidget(id: id);
    }
  }
}
