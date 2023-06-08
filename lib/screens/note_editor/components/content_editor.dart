import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/special_marks_operations/unicode.dart';
import 'package:mobi_note/screens/note_editor/components/paragraph_controller.dart';

import '../../../backend/text_editor/diff/text_operations.dart';

int change = 1;
String lastNewText = "";

class ContentEditor extends StatefulWidget {
  final ParagraphController contentController;
  final Function(String value) onContentChange;
  const ContentEditor(
      {super.key,
      required this.contentController,
      required this.onContentChange});

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  bool contentChanged = false;
  late ParagraphController contentController;
  late Function(String value) onContentChange;

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  String get text => widget.contentController.text;
  set text(String newText) => widget.contentController.text = newText;

  void onChange(String newText) {
    onContentChange(newText);
  }

  @override
  Widget build(BuildContext context) {
    contentController = widget.contentController;
    onContentChange = widget.onContentChange;

    return LayoutBuilder(
      builder: (BuildContext constext, BoxConstraints constraints) {
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: TextField(
                onTap: () {
                  debugPrint(
                      'selected in ${widget.contentController.selection.baseOffset} -> ${widget.contentController.selection.extentOffset}');
                },
                expands: true,
                onChanged: onChange,
                controller: contentController,
                style: const TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.amber,
                ),
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  hintText: 'Enter a note',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
