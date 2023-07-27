import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_checkbox_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_icon_button_widget.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_label_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_text_editor_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_checkbox_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_icon_button_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_text_editor_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

import 'note_label_widget.dart';

class NoteListElementWidget extends NoteEditorWidget {
  NoteListElementData data;

  void Function(int, String)? addNewListElement;

  NoteListElementWidget(
      {required super.id,
      required this.data,
      this.addNewListElement,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.reportEditMode})
      : super(key: ValueKey('ListElement_$id')) {
    data.checkboxData ??= NoteCheckboxData(id: -1, value: false);
    data.textEditorData ??= NoteTextEditorData(id: -1, text: '');
  }

  @override
  void setDefaultCallbacks() {
    addNewListElement = null;
    super.setDefaultCallbacks();
  }

  @override
  State<NoteListElementWidget> createState() => _NoteListElementState();
}

class _NoteListElementState extends State<NoteListElementWidget> {
  late NoteTextEditorWidget textEditor;
  NoteEditorWidgetFactory widgetFactory = NoteEditorWidgetFactory();

  void setModeInState(WidgetMode mode) => setState(() {
        widget.mode = mode;
        textEditor.setMode(mode);
        debugPrint("LIST ELEMENT mode set to: $mode");
      });

  NoteEditorWidget getLabel() {
    int id = 0;
    if (widget.mode == WidgetMode.selected) {
      return NoteIconButtonWidget(
        id: id,
        data: NoteIconButtonData(
          id: -1,
          icon: Icons.disabled_by_default_rounded,
        ),
      )..onPressed = () => widget.removeFromParent?.call(widget.id);
    }
    switch (widget.data.elemType) {
      case ElementType.checkbox:
        return NoteCheckboxWidget(
          id: id,
          data: widget.data.checkboxData!,
          onTrue: () => setState(() => textEditor.strikeText()),
          onFalse: () => setState(() => textEditor.unStrikeText()),
        );
      case ElementType.marks:
        return NoteLabelWidget(
          id: id,
          data: NoteLabelData(id: -1, label: '-'),
        );
      case ElementType.number:
        return NoteLabelWidget(
          id: id,
          data: NoteLabelData(id: -1, label: id.toString()),
        );
      default:
        return NoteLabelWidget(
          id: id,
          data: NoteLabelData(id: -1, label: '*'),
        );
    }
  }

  void addNewListElement(String text) {
    widget.addNewListElement!(widget.id, text);
  }

  void focusOnAction() {
    widget.focusOnAction?.call();
    widget.reportEditMode?.call();
  }

  @override
  void initState() {
    super.initState();
    textEditor = widgetFactory.create(widget.data.textEditorData!)
        as NoteTextEditorWidget;
    textEditor.addNewElement = addNewListElement;
    textEditor.focusOnAction = widget.focusOnAction;
    widget.setModeInState = setModeInState;
    widget.requestFocus = textEditor.requestFocus;
  }

  @override
  void dispose() {
    widget.setDefaultCallbacks();
    super.dispose();
  }

  List<NoteEditorWidget> get elements {
    return [getLabel(), textEditor];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: elements,
    );
  }
}
