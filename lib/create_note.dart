import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'database/database_def.dart';

class NoteEditorPage extends StatefulWidget {
  NoteEditorPage(
      {super.key,
      required this.id,
      required this.title,
      required this.content});
  int id;
  final String title;
  final String content;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  late int id;

  void saveNote() async {
    final database = Get.find<MobiNoteDatabase>();
    final selectedNote = await database.noteWithId(id);

    if (selectedNote == null) {
      id = await database.into(database.notes).insert(NotesCompanion.insert(
          title: titleController.text, content: contentController.text));
    } else {
      final newNote = Note(
          id: widget.id,
          title: titleController.text,
          content: contentController.text);
      database.updateNote(newNote);
    }
  }

  void initFields() {
    id = widget.id;
    titleController.text = widget.title;
    contentController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    initFields();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveNote,
            icon: const Icon(Icons.save),
          )
        ],
        title: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                titleController.clear();
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Note',
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      contentController.clear();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
