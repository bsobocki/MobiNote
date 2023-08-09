import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/helpers/paragraph_analyze.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/all_widget_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_text_editor_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_text/note_text_editor_controller.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/theme/themes.dart';

class NoteTextEditorWidget extends NoteEditorWidget {
  @override
  NoteTextEditorData data;

  void Function(String)? addNewElement;
  late Function(String)? _appendTextInState;
  void Function()? _requestFocus;
  void Function(String)? setControllerTextType;

  NoteTextEditorWidget({
    super.key,
    required super.id,
    required this.data,
    super.onContentChange,
    this.addNewElement,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.removeFromParent,
    super.mode,
  }) {
    data.text = '$placeholder${data.text}';
    requestFocus = () => _requestFocus?.call();
  }

  double fontSize = paragraphDefaultFontSize;
  bool isTextStrike = false;

  void strikeText() {
    isTextStrike = true;
    if (setControllerTextType != null) {
      setControllerTextType!('text_done');
    }
  }

  void unstrikeText() {
    isTextStrike = false;
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
  late NoteTextEditingController controller;
  void resizeTextField(double newSize) => widget.fontSize = newSize;

  bool needToRemove(String text) {
    return text.isEmpty || (text.isNotEmpty && text[0] != placeholder);
  }

  void onChange(String newText) {
    if (focusNode.hasFocus) {
      if (needToRemove(newText)) {
        if (widget.removeFromParent != null) {
          widget.removeFromParent!(widget.id);
        }
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
      widget.onContentChange?.call();
    }
  }

  void appendText(String text) => setState(() {
        controller.text += text;
      });

  @override
  void initState() {
    super.initState();
    widget._requestFocus = () {
      focusNode.requestFocus();
    };
    widget.setControllerTextType = setControllerTextType;
    widget._appendTextInState = appendText;
    controller = NoteTextEditingController(resizeTextField: resizeTextField);
    controller.text = widget.data.text;
    focusNode.addListener(() {
      controller.isFocused = focusNode.hasFocus;
      if (focusNode.hasFocus) {
        if (widget.onInteract != null) {
          widget.onInteract!();
        }
      } else {
        int len = controller.text.length;
        controller.selection =
            TextSelection(baseOffset: len, extentOffset: len);
      }
    });
    if (widget.isTextStrike) {
      setControllerTextType('text_done');
    } else {
      setControllerTextType('');
    }
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
              color: widget.isTextStrike ? MobiNoteTheme.current.textColor.withOpacity(0.5) : MobiNoteTheme.current.textColor,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: padding),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: MobiNoteTheme.current.textColor,
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
