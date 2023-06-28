import 'package:flutter/material.dart';
import 'package:mobi_note/logic/text_editor/parser/mark_text_helpers/paragraph_analyze.dart';
import 'package:mobi_note/logic/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/screens/note_editor/components/paragraph_controller.dart';

class NoteParagraph extends StatefulWidget {
  FocusNode focusNode = FocusNode();
  double fontSize = 12;
  int cursor = 0;
  final int id;
  String paragraphText;
  void Function(String) onChange;
  void Function(int, String) addParagraph;
  void Function(int) deleteParagraph;
  late Function(String) appendText;

  NoteParagraph(
      {required this.id,
      required this.paragraphText,
      required this.onChange,
      required this.addParagraph,
      required this.deleteParagraph})
      : super(key: ValueKey('NoteParagraph_$id'));

  String get text {
    if (paragraphText.isNotEmpty && paragraphText != placeholder) {
      if (paragraphText[0] == placeholder) {
        return paragraphText.substring(1);
      }
      return paragraphText;
    }
    return '';
  }

  String get widgets => '';
  String get str => '$id: $paragraphText';

  @override
  State<NoteParagraph> createState() => _NoteParagraphState();
}

class _NoteParagraphState extends State<NoteParagraph> {
  late ParagraphController controller;

  void onChange(String newText) {
    if (widget.focusNode.hasFocus) {
      if (newText.isEmpty || newText.isNotEmpty && newText[0] != placeholder) {
        widget.deleteParagraph(widget.id);
      }
      setState(() {
        widget.fontSize = paragraphFontSize(newText);
      });
      int i = newText.indexOf('\n');
      if (i != -1) {
        controller.text = newText.substring(0, i);
        widget.addParagraph(widget.id, newText.substring(i + 1));
        widget.focusNode.unfocus();
      }
      widget.paragraphText = controller.text;
      widget.onChange(newText);
    }
  }

  void appendText(String text) {
    controller.text += text;
  }

  void resizeTextField(double newSize) {
    widget.fontSize = newSize;
  }

  @override
  void initState() {
    controller = ParagraphController(resizeTextField: resizeTextField);
    controller.text = '\u200B${widget.paragraphText}';
    controller.selection = const TextSelection(baseOffset: 1, extentOffset: 1);
    widget.fontSize = paragraphFontSize(controller.text);
    widget.appendText = appendText;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // IF FOCUS THEN SHOW TRANSPARENT PARAGRAPH CHARS

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: TextField(
        expands: true,
        // autofocus: true,
        onTap: () {
          if (controller.selection.extentOffset == 0 &&
              controller.text.isNotEmpty) {
            controller.selection =
                const TextSelection(baseOffset: 1, extentOffset: 1);
          }
        },
        // onTapOutside: (event) {
        //   widget.focusNode.unfocus();
        // },
        onChanged: onChange,
        controller: controller,
        focusNode: widget.focusNode,
        style: TextStyle(
            color: Colors.white,
            decorationColor: Colors.amber,
            fontSize: widget.fontSize),
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '',
        ),
      ),
    );
  }
}

/*
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
)
*/