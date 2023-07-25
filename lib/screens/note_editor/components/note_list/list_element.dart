import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_checkbox_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_text_editor_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

import '../note_widgets/note_label_widget.dart';

enum ElementType { checkbox, number, marks, custom }

class NoteListElement extends NoteEditorWidget {
  final int depth;
  final ElementType elemType;
  final int initCounterValue;
  final int infoPageId;

  NoteListElement(
      {super.key,
      required super.id,
      required this.depth,
      required this.elemType,
      this.initCounterValue = -1,
      this.infoPageId = -1,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.widgetType = 'list_element'});

  @override
  State<NoteListElement> createState() => _NoteListElementState();
}

class _NoteListElementState extends State<NoteListElement> {
  NoteTextEditorWidget textEditor = NoteTextEditorWidget(id: 1);

  void setMode(WidgetMode mode) => setState(() {
        widget.mode = mode;
      });

  NoteEditorWidget getLabel() {
    int id = 0;
    switch (widget.elemType) {
      case ElementType.checkbox:
        return NoteCheckboxWidget(
          id: id,
          onTrue: () => setState(() => textEditor.strikeText()),
          onFalse: () => setState(() => textEditor.unStrikeText()),
        );
      case ElementType.marks:
        return NoteLabelWidget(id: id, label: '-');
      case ElementType.number:
        return NoteLabelWidget(id: id, label: id.toString());
      default:
        return NoteLabelWidget(id: id, label: '*');
    }
  }

  @override
  void initState() {
    super.initState();

    widget.elements = [getLabel(), textEditor];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.elements,
    );
  }
}
