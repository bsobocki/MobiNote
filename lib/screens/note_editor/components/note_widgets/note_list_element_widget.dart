import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_checkbox_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_counter_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_icon_button_widget.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_label_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_text_editor_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_checkbox_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_counter_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_icon_button_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_text_editor_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

import 'note_label_widget.dart';

class NoteListElementWidget extends NoteEditorWidget {
  int number;
  bool isChecked = false;
  NoteListElementData data;

  void Function()? _requestFocus;
  void Function(int, String)? addNewListElement;

  NoteListElementWidget(
      {required super.id,
      required this.data,
      required super.widgetFactory,
      this.number = 0,
      this.addNewListElement,
      super.onLongPress,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.reportEditMode,
      super.mode})
      : super(key: ValueKey('ListElement_$id')) {
    data.checkboxData ??= NoteCheckboxData(id: -1, value: false);
    data.counterData ??= NoteCounterData(id: -1, targetValue: 10);
    data.textEditorData ??= NoteTextEditorData(id: -1, text: '');
    requestFocus = () => _requestFocus?.call();
    widgetFactory ??= NoteEditorWidgetFactory();
  }

  @override
  void setDefaultCallbacks() {
    super.setDefaultCallbacks();
    _requestFocus = null;
    requestFocus = () => _requestFocus?.call();
  }

  @override
  State<NoteListElementWidget> createState() => _NoteListElementState();
}

class _NoteListElementState extends State<NoteListElementWidget> {
  late NoteTextEditorWidget textEditor;

  void setModeInState(WidgetMode mode) => setState(() {
        widget.mode = mode;
        textEditor.setMode(mode);
        debugPrint("LIST ELEMENT mode set to: $mode");
      });

  void checkElement(bool isChecked) {
    widget.isChecked = isChecked;
    widget.data.checkboxData!.value = isChecked;

    if (isChecked) {
      widget.data.counterData!.count = widget.data.counterData!.targetValue;
      setState(() => textEditor.strikeText());
    } else {
      widget.data.counterData!.count = 0;
      setState(() => textEditor.unstrikeText());
    }
  }

  NoteEditorWidget getLabel() {
    debugPrint('DATA LABEL CREATION!!!');
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
          onTrue: () => checkElement(true),
          onFalse: () => checkElement(false),
        );
      case ElementType.counter:
        return NoteCounterWidget(
          id: id,
          data: widget.data.counterData!,
          onLongPress: widget.onLongPress,
          onTargetReached: () => checkElement(true),
          onResetCounter: () => checkElement(false),
        );
      case ElementType.marks:
        return NoteLabelWidget(
          id: id,
          data: NoteLabelData(id: -1, label: '-'),
          widgetFactory: widget.widgetFactory,
        );
      case ElementType.number:
        return NoteLabelWidget(
          id: id,
          data: NoteLabelData(id: -1, label: '${widget.data.number}.'),
          widgetFactory: widget.widgetFactory,
        );
      default:
        return NoteLabelWidget(
          id: id,
          data: NoteLabelData(id: -1, label: '*'),
          widgetFactory: widget.widgetFactory,
        );
    }
  }

  void addNewListElement(String text) {
    widget.addNewListElement?.call(widget.id, text);
  }

  void focusOnAction() {
    widget.focusOnAction?.call();
    widget.reportEditMode?.call();
  }

  @override
  void initState() {
    super.initState();
    widget.stateCounter++;
    textEditor = widget.widgetFactory!.create(widget.data.textEditorData!)
        as NoteTextEditorWidget;
    textEditor.addNewElement = addNewListElement;
    textEditor.focusOnAction = widget.focusOnAction;
    if (widget.data.elemType == ElementType.counter ||
        widget.data.elemType == ElementType.checkbox) {
      textEditor.isTextStrike = widget.isChecked;
    }
    widget.setModeInState = setModeInState;
    widget.requestFocus = textEditor.requestFocus;
    debugPrint('ListElement => SET IT');
    widget.forceSetState = () => setState(() {});
  }

  @override
  void dispose() {
    widget.stateCounter--;
    if (widget.removingState) widget.setDefaultCallbacks();
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