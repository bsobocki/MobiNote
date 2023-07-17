import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_list/list_element.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import '../note_widgets/definitions/widget_mode.dart';

class NoteListWidget extends NoteEditorWidget {
  NoteListWidget({super.key});

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  WidgetMode mode = WidgetMode.edit;

  @override
  void initState() {
    super.initState();
  }

  Widget createEditMode() {
    return Column(
      children: [
        
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.elements,
    );
  }
}
