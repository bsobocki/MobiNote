import 'package:flutter/material.dart';
import 'package:mobi_note/backend/text_editor/special_marks_operations/unicode.dart';
import 'package:mobi_note/screens/note_editor/components/paragraph_controller.dart';

import '../../../backend/text_editor/diff/text_operations.dart';

int change = 1;

class ContentEditor extends StatefulWidget {
  final ParagraphController contentController;
  final Function(String value) onContentChange;
  const ContentEditor(
      {super.key,
      required this.contentController,
      required this.onContentChange});

  void onChange(String newText) {
    if (contentController.markedText.isEmpty) {
      contentController.markedText = newText;
      contentController.parseMarkdownText();
      onContentChange(newText);
      return;
    }
    debugPrint('');
    debugPrint('');
    debugPrint("change: ${change++}");
    debugPrint('====================');
    debugPrint(contentController.prevText);
    debugPrint('====================');
    debugPrint('--------------');
    debugPrint(newText);
    debugPrint('--------------');

    var selection = contentController.selection;

    var position = 0;
    for (position; position < newText.length; position++) {
      if (contentController.prevText.length == position) {
        break;
      } else if (contentController.prevText[position] != newText[position]) {
        debugPrint(
            "difference: ${contentController.prevText[position]} : ${newText[position]}");
        break;
      }
    }

    debugPrint("changed position: $position");

    var diffLength = newText.length - contentController.prevText.length;
    debugPrint("diff length: $diffLength");
    debugPrint("selection before on: ${contentController.selection}");

    // TextSelection selection =
    //     TextSelection(baseOffset: newText.length, extentOffset: newText.length);
    var marked = List.from(contentController.markedText.characters);
    var markedPosition =
        getStyledTextIndexOf(contentController.unicodeMarkedText, position);

    if (diffLength < 0) {
      debugPrint("marked before remove : $marked");
      debugPrint("remove at: $markedPosition : ${marked[markedPosition]}");
      marked.removeAt(markedPosition);
      debugPrint("marked after remove : $marked");
      //selection = TextSelection(baseOffset: position, extentOffset: position);
    } else if (diffLength > 0) {
      marked.insert(
          markedPosition, newText.substring(position, position + diffLength));
      debugPrint("markedL ${marked}");
      // selection = TextSelection(
      //     baseOffset: position + diffLength,
      //     extentOffset: position + diffLength);
    }

    debugPrint("selection after on: $selection");

    contentController.markedText = marked.join('');
    contentController.parseMarkdownText();
    // try {
    //   contentController.selection = selection;
    // }
    // catch(e) {
    //   contentController.selection = TextSelection(baseOffset: contentController.prevText.length, extentOffset: contentController.prevText.length);
    // }
    onContentChange(newText);
  }

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  bool contentChanged = false;

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
                onChanged: widget.onChange,
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
