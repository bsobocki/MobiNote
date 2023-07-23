import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/screens/note_editor/components/note_text/note_paragraph_controller.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteTextEditorWidget extends NoteEditorWidget {
  NoteTextEditorWidget(
      {super.key, required super.id, super.type = 'text_editor'});
  double fontSize = paragraphDefaultFontSize;
  bool isTextStrike = false;

  void Function()? setState;

  void strikeText() {
    isTextStrike = true;
    debugPrint('TEXT EDITOR WIDGET: set strike to $isTextStrike');
    if (setState != null) {
      setState!();
    } else {
      debugPrint('setState is NULL!!!!!!!!!!!');
    }
  }

  void unStrikeText() {
    isTextStrike = false;
    debugPrint('TEXT EDITOR WIDGET: set strike to $isTextStrike');
    if (setState != null) {
      setState!();
    }
  }

  @override
  State<NoteTextEditorWidget> createState() => _NoteTextEditorWidgetState();
}

class _NoteTextEditorWidgetState extends State<NoteTextEditorWidget> {
  late ParagraphController controller;
  void resizeTextField(double newSize) => widget.fontSize = newSize;

  @override
  void initState() {
    super.initState();
    widget.setState = () => setState(() {});
    controller = ParagraphController(resizeTextField: resizeTextField);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IntrinsicHeight(
          child: TextField(
            expands: true,
            maxLines: null,
            style: TextStyle(
              fontSize: widget.fontSize,
            ),
            controller: controller,
          ),
        ),
      ),
    );
  }
}
