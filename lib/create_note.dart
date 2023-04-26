import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'database/database_def.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key, required this.title});
  final String title;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void saveNote() async {
    final database = Get.find<MobiNoteDatabase>();
    await database.into(database.notes).insert(NotesCompanion.insert(
        title: titleController.text, content: contentController.text));
  }

  @override
  Widget build(BuildContext context) {
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
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
