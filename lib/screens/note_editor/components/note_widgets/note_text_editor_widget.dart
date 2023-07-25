import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/helpers/paragraph_analyze.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/screens/note_editor/components/note_text/note_paragraph_controller.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteTextEditorWidget extends NoteEditorWidget {
  String elementText;
  void Function(int, String) addNewElement;
  void Function(String)? onChange;
  late Function(String)? _appendTextInState;

  NoteTextEditorWidget({
    super.key,
    required super.id,
    required this.elementText,
    required this.addNewElement,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.removeFromParent,
    super.widgetType = 'text_editor',
  }) {
    elementText = '$placeholder$elementText';
  }

  double fontSize = paragraphDefaultFontSize;
  bool isTextStrike = false;

  void Function(String)? setControllerTextType;

  void strikeText() {
    isTextStrike = true;
    debugPrint('TEXT EDITOR WIDGET: set strike to $isTextStrike');
    if (setControllerTextType != null) {
      setControllerTextType!('strikethrough');
    } else {
      debugPrint('setState is NULL!!!!!!!!!!!');
    }
  }

  void unStrikeText() {
    isTextStrike = false;
    debugPrint('TEXT EDITOR WIDGET: set strike to $isTextStrike');
    if (setControllerTextType != null) {
      setControllerTextType!('');
    }
  }

  void append(String text) {
    if (_appendTextInState == null) {
      elementText += text;
    } else {
      _appendTextInState!(text);
    }
  }

  @override
  String get text {
    if (elementText.isNotEmpty && elementText != placeholder) {
      if (elementText[0] == placeholder) {
        return elementText.substring(1);
      }
      return elementText;
    }
    return '';
  }

  @override
  State<NoteTextEditorWidget> createState() => _NoteTextEditorWidgetState();
}

class _NoteTextEditorWidgetState extends State<NoteTextEditorWidget> {
  FocusNode focusNode = FocusNode();
  late ParagraphController controller;
  void resizeTextField(double newSize) => widget.fontSize = newSize;

  bool needToRemove(String text) {
    return text.isEmpty || (text.isNotEmpty && text[0] != placeholder);
  }

  void onChange(String newText) {
    var replacedPlaceholder = newText.replaceAll(placeholder, "+");

    if (focusNode.hasFocus) {
      if (needToRemove(newText)) {
        if (widget.removeFromParent != null) {
          widget.removeFromParent!(widget.id);
        }
      } else {
        debugPrint("in $replacedPlaceholder there is \\u200b");
      }

      setState(() => widget.fontSize = paragraphFontSize(newText));

      int newLineIndex = newText.indexOf('\n');
      if (exists(newLineIndex)) {
        controller.text = newText.substring(0, newLineIndex);
        widget.addNewElement(widget.id, newText.substring(newLineIndex + 1));
        focusNode.unfocus();
      }

      widget.elementText = controller.text;
      if (widget.onChange != null) {
        widget.onChange!(newText);
      }
    }
  }

  void appendText(String text) => setState(() {
        debugPrint('appending curr: "${controller.text}" with text "$text" ');
        controller.text += text;
        debugPrint('new Text is : ${controller.text}');
      });

  @override
  void initState() {
    super.initState();
    widget.setControllerTextType = setControllerTextType;
    widget._appendTextInState = appendText;
    controller = ParagraphController(resizeTextField: resizeTextField);
    controller.text = widget.elementText;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (widget.onInteract != null) {
          widget.onInteract!();
        }
      }
    });
  }

  void setControllerTextType(String newType) => setState(() {
        controller.setMainType(newType);
      });

  @override
  Widget build(BuildContext context) {
    var padding = 4 + (widget.fontSize - paragraphDefaultFontSize) / 5;
    debugPrint(
        'BUILD TEXTFIELD: padding = $padding, widget.font size = ${widget.fontSize}');
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IntrinsicHeight(
          child: TextField(
            key: ValueKey('ListElement_TextEditor_${widget.id}'),
            autofocus: true,
            onTap: widget.onInteract,
            onChanged: onChange,
            focusNode: focusNode,
            expands: true,
            maxLines: null,
            style: TextStyle(
              fontSize: widget.fontSize,
            ),
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: padding)),
            controller: controller,
          ),
        ),
      ),
    );
  }
}
