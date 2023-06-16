import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/screens/note_editor/components/content_editor.dart';
import '../../database/database_def.dart';
import 'components/paragraph_controller.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage(
      {super.key,
      required this.id,
      required this.title,
      required this.content});
  final int id;
  final String title;
  final String content;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final contentController = ParagraphController();
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
              content: contentController.text);
          await database.updateNote(newNote);
        } else {
          id = await database.addNote(
              titleController.text, contentController.text);
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
    contentController.parseText();
  }

  void onContentChange(value) {
    noteChanged = true;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //init();

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
          cursorColor: Colors.white,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
        leading: IconButton(
          onPressed: saveAndExit,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ContentEditor(
        contentController: contentController,
        onContentChange: onContentChange,
      ),
      backgroundColor: const Color.fromARGB(
        255,
        75,
        75,
        75,
      ),
    );
  }
}


// _textEditingController.selection.textInside(_textEditingController.text)