import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/helpers/paragraph_analyze.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_text_editor_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_text/note_paragraph_controller.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteTextEditorWidget extends NoteEditorWidget {
  NoteTextEditorData data;
  void Function(String)? addNewElement;
  void Function(String)? onChange;
  late Function(String)? _appendTextInState;
  void Function()? _requestFocus;
  void Function(String)? setControllerTextType;

  NoteTextEditorWidget(
      {super.key,
      required super.id,
      required this.data,
      this.addNewElement,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.mode}) {
    data.text = '$placeholder${data.text}';
    requestFocus = () => _requestFocus?.call();
  }

  double fontSize = paragraphDefaultFontSize;
  bool isTextStrike = false;

  void strikeText() {
    isTextStrike = true;
    debugPrint('TEXT EDITOR WIDGET: set strike to $isTextStrike');
    if (setControllerTextType != null) {
      setControllerTextType!('text_done');
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
      data.text += text;
    } else {
      _appendTextInState!(text);
    }
  }

  String get text {
    if (data.text.isNotEmpty && data.text != placeholder) {
      if (data.text[0] == placeholder) {
        return data.text.substring(1);
      }
      return data.text;
    }
    return '';
  }

  @override
  void setDefaultCallbacks() {
    super.setDefaultCallbacks();
    requestFocus = () => _requestFocus?.call();
    _appendTextInState = null;
    _requestFocus = null;
    setControllerTextType = null;
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
        if (widget.addNewElement != null) {
          controller.text = newText.substring(0, newLineIndex);
          widget.addNewElement!(newText.substring(newLineIndex + 1));
        }
        focusNode.unfocus();
      }

      widget.data.text = controller.text;
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
    widget._requestFocus = () {
      debugPrint("request focus on the textfield");
      focusNode.requestFocus();
    };
    widget.setControllerTextType = setControllerTextType;
    widget._appendTextInState = appendText;
    controller = ParagraphController(resizeTextField: resizeTextField);
    controller.text = widget.data.text;
    focusNode.addListener(() {
      debugPrint("TextField with text: ${controller.text}");
      if (focusNode.hasFocus) {
        debugPrint('Has FOCUS!!!');
        if (widget.onInteract != null) {
          widget.onInteract!();
        }
      } else {
        debugPrint("Doesn't have FOCUS!! :(");
      }
    });
  }

  @override
  void dispose() {
    widget.setDefaultCallbacks();
    super.dispose();
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
            readOnly: widget.mode == WidgetMode.selected,
            onTap: widget.onInteract,
            onChanged: onChange,
            focusNode: focusNode,
            expands: true,
            maxLines: null,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: widget.isTextStrike ? Colors.grey : Colors.white,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: padding),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            controller: controller,
          ),
        ),
      ),
    );
  }
}
