import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteListElement extends NoteEditorWidget {
  NoteListElement({super.key, required super.id, super.type = 'list'});

  @override
  State<NoteListElement> createState() => _NoteListElementState();
}

class _NoteListElementState extends State<NoteListElement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.elements,
    );
  }
}
