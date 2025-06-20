import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/screens/theme/themes.dart';
import '../../database/database_def.dart';

class RawNoteEditorTestPage extends StatefulWidget {
  const RawNoteEditorTestPage(
      {super.key,
      required this.id,
      required this.title,
      required this.content});
  final int id;
  final String title;
  final String content;

  @override
  State<RawNoteEditorTestPage> createState() => _RawNoteEditorTestPageState();
}

class _RawNoteEditorTestPageState extends State<RawNoteEditorTestPage> {
  late final contentController = TextEditingController();
  late int id;
  final database = Get.find<MobiNoteDatabase>();
  final titleController = TextEditingController();
  bool noteChanged = false;
  bool wantToSaveNote = true;

  Future<void> saveNote() async {
    if (wantToSaveNote && noteChanged) {
      try {
        final selectedNote = await database.getNoteWithId(id);

        if (selectedNote != null) {
          final newNote = Note(
              id: id,
              title: titleController.text,
              content: contentController.text,
              widgets: '');
          await database.updateNote(newNote);
        } else {
          id = await database.addNote(
              titleController.text, contentController.text, '');
        }
      } catch (e) {
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(
                      'Cannot save note with id: $id! cause: ${e.toString()}!'),
                ));
      }
    }
  }

  void saveAndExit() async {
    await saveNote().then((value) => Navigator.pop(context));
  }

  void init() {
    id = widget.id;
    titleController.text = widget.title;
    contentController.text = widget.content;
  }

  void onContentChange(value) {
    noteChanged = true;
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        actions: [
          Switch(
            value: wantToSaveNote,
            onChanged: (value) {
              setState(() {
                wantToSaveNote = value;
              });
            },
            activeColor: const Color.fromARGB(255, 133, 226, 26),
            activeTrackColor: const Color.fromARGB(255, 193, 250, 127),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
        title: TextField(
          controller: titleController,
          onChanged: (value) => noteChanged = true,
          cursorColor: MobiNoteTheme.current.textColor,
          style: TextStyle(
            fontSize: 20,
            color: MobiNoteTheme.current.textColor,
          ),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
        leading: IconButton(
          onPressed: saveAndExit,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: TextField(
        controller: contentController,
        maxLines: null,
        onChanged: onContentChange,
        style: TextStyle(
            fontSize: 20,
            color: MobiNoteTheme.current.textColor,
          ),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
      backgroundColor: MobiNoteTheme.current.siteBackgroundColor,
    );
  }
}


// _textEditingController.selection.textInside(_textEditingController.text)