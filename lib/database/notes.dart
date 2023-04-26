import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'database_def.dart';

class NoteWidget extends StatelessWidget {
  final Note note;

  const NoteWidget(
      {super.key,
      required this.note,
      required this.noteAction,
      required this.updateViewAction});

  final Function(int, String, String) noteAction;
  final Function updateViewAction;

  void callNoteAction() => noteAction(note.id, note.title, note.content);

  void deleteNote() async {
    await Get.find<MobiNoteDatabase>().deleteNote(note.id);
    updateViewAction();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: callNoteAction,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth / 1.75,
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Text(
                      note.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                IconButton(
                    onPressed: deleteNote,
                    icon: const Icon(Icons.delete_forever_rounded))
              ],
            ),
          );
        },
      ),
    );
  }
}
