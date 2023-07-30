import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';
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

  late Function(String)? _appendTextInState;
  late Function()? _addPlaceholderInState;

  NoteParagraphTextEditor(
      {required super.id,
      required super.widgetFactory,
      required super.reportFocusParagraph,
      required this.paragraphText,
      required this.onChange,
      required this.addParagraph,
      required super.deleteParagraph})
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

  void addPlaceholder() {
    if (_addPlaceholderInState == null) {
      paragraphText = placeholder + paragraphText;
    } else {
      _addPlaceholderInState!();
    }
  }

  void append(String text) {
    if (_appendTextInState == null) {
      paragraphText += text;
    } else {
      _appendTextInState!(text);
    }
  }

  @override
  void setDefaultCallbacks() {
    _appendTextInState = null;
    _addPlaceholderInState = null;
    super.setDefaultCallbacks();
  }

  @override
  int get rawLength => paragraphText.length;
  @override
  String get widgetTree => '';
  @override
  String get str => '$id: $paragraphText';

  @override
  State<NoteParagraphTextEditor> createState() => _NoteParagraphEditorState();
}

class _NoteParagraphEditorState extends State<NoteParagraphTextEditor> {
  late ParagraphController controller;
  FocusNode focusNode = FocusNode();

  void resizeTextField(double newSize) => widget.fontSize = newSize;

  bool needToDelete(String text) {
    return text.isEmpty || (text.isNotEmpty && text[0] != placeholder);
  }

  void appendText(String text) => setState(() {
        debugPrint('appending curr: "${controller.text}" with text "$text" ');
        controller.text += text;
        debugPrint('new Text is : ${controller.text}');
      });

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
    var replacedPlaceholder = newText.replaceAll(placeholder, "+");

    if (focusNode.hasFocus) {
      if (needToDelete(newText)) {
        widget.deleteParagraph(widget.id);
      } else {
        debugPrint("in $replacedPlaceholder there is \\u200b");
      }

      setState(() => widget.fontSize = paragraphFontSize(newText));

      int newLineIndex = newText.indexOf('\n');
      if (exists(newLineIndex)) {
        controller.text = newText.substring(0, newLineIndex);
        widget.addParagraph(widget.id, newText.substring(newLineIndex + 1));
        focusNode.unfocus();
      }

      widget.paragraphText = controller.text;
      widget.onChange(newText);
    }
  }

  void addPlaceholder() {
    var replacedPlaceholder = controller.text.replaceAll(placeholder, "+");
    debugPrint("we want to add placeholder to '$replacedPlaceholder'");
    if (controller.text.isEmpty || controller.text[0] != placeholder) {
      controller.text = placeholder + controller.text;
      debugPrint(
          "placeholder added! for '${controller.text.replaceAll(placeholder, '+')}");
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('initStatee!!!!!!!');
    widget.requestFocusInState = () => focusNode.requestFocus();
    controller = ParagraphController(resizeTextField: resizeTextField);
    controller.text = widget.paragraphText;
    controller.selection = const TextSelection(baseOffset: 1, extentOffset: 1);
    widget.fontSize = paragraphFontSize(controller.text);
    widget._appendTextInState = appendText;
    widget._addPlaceholderInState = addPlaceholder;
    focusNode.addListener(foucusAction);
    if (!widget.isInitialized) {
      focusNode.requestFocus();
      widget.isInitialized = true;
    }
  }

  @override
  void dispose() {
    debugPrint('dispose!!!!!!!');
    controller.dispose();
    widget.setDefaultCallbacks();
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
