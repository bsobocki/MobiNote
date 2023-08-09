import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_checkbox_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/theme/themes.dart';

class NoteCheckboxWidget extends NoteEditorWidget {
  @override
  NoteCheckboxData data;

  void Function()? onTrue;
  void Function()? onFalse;

  NoteCheckboxWidget(
      {super.key,
      required super.id,
      required this.data,
      super.onContentChange,
      this.onTrue,
      this.onFalse,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.mode});

  @override
  State<NoteCheckboxWidget> createState() => _NoteCheckboxWidgetState();
}

class _NoteCheckboxWidgetState extends State<NoteCheckboxWidget> {
  Color color = MobiNoteTheme.current.textColor;

  void callValueCallback() {
    if (widget.data.value) {
      callIfNotNull(widget.onTrue);
    } else {
      callIfNotNull(widget.onFalse);
    }
  }

  void onChanged(bool? newValue) => setState(() {
        if (newValue != null) {
          widget.data.value = newValue;

          callValueCallback();
        }
        widget.onContentChange?.call();
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Checkbox(
        value: widget.data.value,
        onChanged: onChanged,
        checkColor: MobiNoteTheme.current.textColor,
        activeColor: MobiNoteTheme.current.textColor,
        fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return MobiNoteTheme.current.buttonBackgroundColor;
          }
          return MobiNoteTheme.current.textColor;
        }),
        overlayColor: MaterialStatePropertyAll(MobiNoteTheme.current.textColor),
      ),
    );
  }
}
