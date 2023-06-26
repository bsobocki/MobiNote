import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobi_note/logic/text_editor/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/text_editor/parser/mark_text_helpers/paragraph_analyze.dart';
import 'package:mobi_note/screens/note_editor/components/paragraph_controller.dart';

int change = 0;

class NoteParagraph extends StatefulWidget {
  double fontSize = 12;
  String paragraphText;
  int cursor = 0;
  void Function(String) onChange;
  void Function(int, String) addParagraph;
  final int id = paragraphIdGenerator.nextId;

  NoteParagraph(
      {super.key,
      required this.paragraphText,
      required this.onChange,
      required this.addParagraph});

  String get text => paragraphText;
  String get widgets => '';
  String get str => '$id: $paragraphText';

  @override
  State<NoteParagraph> createState() => _NoteParagraphState();
}

class _NoteParagraphState extends State<NoteParagraph> {
  late ParagraphController controller;

  void onChange(String newText) {
    widget.cursor = controller.selection.baseOffset;
    setState(() {
      widget.fontSize = paragraphFontSize(newText);
      controller.selection =
          TextSelection(baseOffset: widget.cursor, extentOffset: widget.cursor);
    });

    int i = 0;
    for (; i < newText.length; i++) {
      if (newText[i] == '\n') break;
    }

    if (i < newText.length) {
      controller.text = newText.substring(0, i);
      widget.addParagraph(widget.id, newText.substring(i).replaceAll('\n', ''));
    }

    widget.paragraphText = controller.text;
    widget.onChange(newText);
  }

  void resizeTextField(double newSize) {
    debugPrint('resized from ${widget.fontSize} to $newSize');
    widget.fontSize = newSize;
  }

  @override
  void initState() {
    controller = ParagraphController(resizeTextField: resizeTextField);
    controller.text = widget.paragraphText;
    widget.fontSize = paragraphFontSize(widget.paragraphText);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return IntrinsicHeight(
    return SizedBox(
      height: widget.fontSize * 1.4,
      child: TextField(
        onTap: () {
          // debugPrint(
          //     'selected in ${widget.contentController.selection.baseOffset} -> ${widget.contentController.selection.extentOffset}');
        },
        expands: true,
        onChanged: onChange,
        controller: controller,
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