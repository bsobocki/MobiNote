import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../database/database_def.dart';
import 'components/paragraph.dart';

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
  late final contentController = ParagraphController(mapping: {
    '\ufffa': TextSpan(children: [
      WidgetSpan(
        child: Image.asset('images/capsule_tree.png'),
      ),
    ]),
    '\ufffe': TextSpan(
      children: [
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: SizedBox(
              width: Checkbox.width,
              height: Checkbox.width,
              child: Checkbox(
                onChanged: (val) {},
                value: val,
                activeColor: Colors.transparent,
                checkColor: Colors.grey,
                focusColor: Colors.white,
                hoverColor: Colors.white,
              ),
            ),
          ),
        )
      ],
    ),
    '\uffff': const TextSpan(
      children: [
        WidgetSpan(
          child: SizedBox(
            child: Icon(Icons.flutter_dash),
          ),
        )
      ],
    ),
    '\ufffb': TextSpan(
      children: [
        WidgetSpan(
          style: const TextStyle(fontSize: 30),
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                        title: Text('Button has been clicked!'),
                      )),
              child: const Text("kliknij"),
            ),
          ),
        )
      ],
    ),
    '\ufffc': const TextSpan(
      style: TextStyle(color: Colors.red, fontSize: 30),
      text: 'to jest czerwony wstawiony text',
    )
  });
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
  }

  void onContentChange(value) {
    noteChanged = true;
    var newValue = value
        .replaceAll("<dog>", '\uffff')
        .replaceAll("[ ] ", '\ufffe')
        .replaceAll("[b] ", '\ufffb')
        .replaceAll("<img>", '\ufffa')
        .replaceAll("<red>", '\ufffc');
    if (newValue == value) return;

    contentController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newValue.length),
      ),
    );
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
      backgroundColor: const Color.fromARGB(255, 75, 75, 75),
      body: TextField(
        onChanged: onContentChange,
        controller: contentController,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          decorationColor: Colors.amber,
        ),
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter a note',
        ),
      ),
    );
  }
}
