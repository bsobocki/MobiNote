import 'package:flutter/material.dart';
import 'package:mobi_note/logic/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/screens/note_editor/components/note_text/paragraph_controller.dart';

import '../../../../logic/text_editor/parser/helpers/paragraph_analyze.dart';

const int textBegginingOffset = 1;

class NoteParagraphEditor extends StatefulWidget {
  bool isInitialized = false;
  double fontSize = 12;
  int cursor = 1;
  final int id;
  String paragraphText;
  void Function(String) onChange;
  void Function(int, String) addParagraph;
  void Function(int) deleteParagraph;
  late Function(String)? appendControllerText;

  NoteParagraphEditor(
      {required this.id,
      required this.paragraphText,
      required this.onChange,
      required this.addParagraph,
      required this.deleteParagraph})
      : super(key: ValueKey('NoteParagraph_$id')) {
    paragraphText = '$placeholder$paragraphText';
  }

  String get text {
    if (paragraphText.isNotEmpty && paragraphText != placeholder) {
      if (paragraphText[0] == placeholder) {
        return paragraphText.substring(1);
      }
      return paragraphText;
    }
    return '';
  }

  void append(String text) {
    if (appendControllerText == null) {
      paragraphText += text;
    } else {
      appendControllerText!(text);
    }
  }

  int get rawLength => paragraphText.length;
  String get widgets => '';
  String get str => '$id: $paragraphText';

  @override
  State<NoteParagraphEditor> createState() => _NoteParagraphEditorState();
}

class _NoteParagraphEditorState extends State<NoteParagraphEditor> {
  late ParagraphController controller;
  FocusNode focusNode = FocusNode();

  void resizeTextField(double newSize) => widget.fontSize = newSize;

  void onChange(String newText) {
    var no200bchar = newText.replaceAll(placeholder, "+");
    if (focusNode.hasFocus) {
      if (newText.isEmpty ||
          (newText.isNotEmpty && newText[0] != placeholder)) {
        widget.deleteParagraph(widget.id);
      } else {
        debugPrint("in $no200bchar there is \\u200b");
      }
      setState(() {
        widget.fontSize = paragraphFontSize(newText);
      });
      int i = newText.indexOf('\n');
      if (i != -1) {
        controller.text = newText.substring(0, i);
        widget.addParagraph(widget.id, newText.substring(i + 1));
        focusNode.unfocus();
      }
      widget.paragraphText = controller.text;
      widget.onChange(newText);
    }
  }

  void appendText(String text) {
    setState(() {
      debugPrint('appending curr: "${controller.text}" with text "$text" ');
      controller.text += text;
      debugPrint('new Text is : ${controller.text}');
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        ParagraphController(id: widget.id, resizeTextField: resizeTextField);
    controller.text = widget.paragraphText;
    controller.selection = const TextSelection(baseOffset: 1, extentOffset: 1);
    widget.fontSize = paragraphFontSize(controller.text);
    widget.appendControllerText = appendText;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (widget.cursor != textBegginingOffset) {
          controller.selection = TextSelection(
              baseOffset: widget.cursor, extentOffset: widget.cursor);
          widget.cursor = textBegginingOffset;
        }
      } else {
        int len = controller.text.length;
        controller.selection = TextSelection(
            baseOffset: len, extentOffset: len);
      }
      controller.isFocused = focusNode.hasFocus;
    });
    if (!widget.isInitialized) {
      focusNode.requestFocus();
      widget.isInitialized = true;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    widget.appendControllerText = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: TextField(
        expands: true,
        onTap: () {
          if (controller.text.isNotEmpty &&
              controller.selection.extentOffset == 0) {
            controller.selection = const TextSelection(
              baseOffset: textBegginingOffset,
              extentOffset: textBegginingOffset,
            );
          }
        },
        onChanged: onChange,
        controller: controller,
        focusNode: focusNode,
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