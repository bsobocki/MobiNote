import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteCheckboxWidget extends NoteEditorWidget {
  bool value = false;
  void Function() onTrue;
  void Function() onFalse;

  NoteCheckboxWidget({super.key, required this.onTrue, required this.onFalse});

  @override
  State<NoteCheckboxWidget> createState() => _NoteCheckboxWidgetState();
}

class _NoteCheckboxWidgetState extends State<NoteCheckboxWidget> {
  void onChanged(bool? newValue) {
    if (newValue != null) {
      widget.value = newValue;

      if (newValue) {
        widget.onTrue();
      } else {
        widget.onFalse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(value: widget.value, onChanged: onChanged);
  }
}
