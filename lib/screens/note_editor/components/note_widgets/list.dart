import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/list_element.dart';

class NoteListWidget extends StatefulWidget {
  const NoteListWidget({super.key});

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  List<NoteListElement> elements = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: elements,
    );
  }
}