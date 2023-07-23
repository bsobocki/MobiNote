import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_checkbox_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_text_editor_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteListElement extends NoteEditorWidget {
  NoteListElement({super.key, required super.id, super.type = 'list'});

  @override
  State<NoteListElement> createState() => _NoteListElementState();
}

class _NoteListElementState extends State<NoteListElement> {
  NoteCheckboxWidget checkbox = NoteCheckboxWidget(id: 0);
  NoteTextEditorWidget textEditor = NoteTextEditorWidget(id: 1);

  @override
  void initState() {
    super.initState();
    checkbox.onTrue = () => setState(() => textEditor.strikeText());
    checkbox.onFalse =() => setState(() => textEditor.unStrikeText());
    widget.elements = [
      checkbox,
      textEditor
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: widget.elements,
      ),
    );
  }
}
