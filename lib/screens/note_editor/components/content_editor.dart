import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/obsolete/obsolete_paragraph_controller.dart';

class ContentEditor extends StatefulWidget {
  const ContentEditor({super.key, required this.contentController});
  final ParagraphController contentController;

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  bool contentChanged = false;

  void onContentChange(value) {
    contentChanged = true;
    var newValue = value
        .replaceAll("<dog>", '\uffff')
        .replaceAll("[ ] ", '\ufffe')
        .replaceAll("[b] ", '\ufffb')
        .replaceAll("<img>", '\ufffa')
        .replaceAll("<red>", 'to jest czerwony wstawiony text');
    if (newValue == value) return;

    widget.contentController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newValue.length),
      ),
    );
  }

  String get text => widget.contentController.text;
  set text(String newText) => widget.contentController.text = newText;

  @override
  Widget build(BuildContext context) {
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
                onChanged: onContentChange,
                controller: widget.contentController,
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
