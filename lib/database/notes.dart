import 'package:flutter/material.dart';

import 'database_def.dart';

class NoteWidget extends StatelessWidget {
  final Note note;

  const NoteWidget({super.key, required this.note, required this.noteAction});

  final Function(int, String, String) noteAction;

  void callNoteAction() {
    noteAction(note.id, note.title, note.content);
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
          );
        },
      ),
    );
  }
}
