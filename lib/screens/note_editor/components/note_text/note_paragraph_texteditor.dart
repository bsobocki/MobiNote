import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_text/note_paragraph_controller.dart';

import '../../../../logic/note_editor/text_editor/parser/helpers/paragraph_analyze.dart';

const int textBegginingOffset = 1;

// ignore: must_be_immutable
class NoteParagraphTextEditor extends NoteParagraph {
  bool isInitialized = false;
  double fontSize = 12;
  int cursor = 1;
  String paragraphText;
  void Function(String) onChange;
  void Function(int, String) addParagraph;
  void Function(int) deleteParagraph;

  late Function(String)? appendControllerText;
  late Function()? addPlaceholder;

  NoteParagraphTextEditor(
      {required super.id,
      required super.reportFocusParagraph,
      required this.paragraphText,
      required this.onChange,
      required this.addParagraph,
      required this.deleteParagraph})
      : super(key: ValueKey('NoteParagraph_$id')) {
    paragraphText = '$placeholder$paragraphText';
  }

  @override
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

  @override
  int get rawLength => paragraphText.length;
  @override
  String get widgets => '';
  @override
  String get str => '$id: $paragraphText';

  @override
  State<NoteParagraphTextEditor> createState() => _NoteParagraphEditorState();
}

class _NoteParagraphEditorState extends State<NoteParagraphTextEditor> {
  late ParagraphController controller;
  FocusNode focusNode = FocusNode();

  void resizeTextField(double newSize) => widget.fontSize = newSize;

  void appendText(String text) {
    setState(() {
      debugPrint('appending curr: "${controller.text}" with text "$text" ');
      controller.text += text;
      debugPrint('new Text is : ${controller.text}');
    });
  }

  void foucusAction() {
    if (focusNode.hasFocus) {
      widget.reportFocusParagraph(widget.id);
      if (widget.cursor != textBegginingOffset) {
        controller.selection = TextSelection(
            baseOffset: widget.cursor, extentOffset: widget.cursor);
        widget.cursor = textBegginingOffset;
      }
    } else {
      int len = controller.text.length;
      controller.selection = TextSelection(baseOffset: len, extentOffset: len);
    }
    controller.isFocused = focusNode.hasFocus;
  }

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

  void addPlaceholder() {
    var no200bchar = controller.text.replaceAll(placeholder, "+");
    debugPrint("we want to add placeholder to '$no200bchar'");
    if (controller.text.isEmpty || controller.text[0] != placeholder) {
      controller.text = placeholder + controller.text;
      debugPrint("placeholder added! for '${controller.text.replaceAll(placeholder, '+')}");
    }
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
    widget.addPlaceholder = addPlaceholder;
    focusNode.addListener(foucusAction);
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
    double paddingVertical = (widget.fontSize - paragraphDefaultFontSize) + 2;
    double paddingHorizontal = 4;
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(
          top: paddingVertical,
          bottom: paddingVertical,
          left: paddingHorizontal,
          right: paddingHorizontal,
        ),
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
      ),
    );
  }
}
