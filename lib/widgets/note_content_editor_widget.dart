import 'package:flutter/material.dart';

const double noteContentPadding = 10.0;
const double noteContentFontSize = 16.0;

class NoteContentEditor extends StatefulWidget {
  const NoteContentEditor({super.key, required this.onChanged, required this.contentController,});

  final TextEditingController contentController;
  final Function(String) onChanged;

  @override
  State<NoteContentEditor> createState() => _NoteContentEditorState();
}

class _NoteContentEditorState extends State<NoteContentEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 75, 75, 75)
        ),
        child: Padding(
          padding: const EdgeInsets.all(noteContentPadding),
          child: Column(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onChanged: widget.onChanged,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: noteContentFontSize,
                  ),
                  controller: widget.contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
                ),
              )
            ],
          ),
        ),
      );
  }
}