import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_checkbox_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteCheckboxWidget extends NoteEditorWidget {
  NoteCheckboxData data;
  void Function()? onTrue;
  void Function()? onFalse;

  NoteCheckboxWidget(
      {super.key,
      required super.id,
      required this.data,
      this.onTrue,
      this.onFalse,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent});

  @override
  State<NoteCheckboxWidget> createState() => _NoteCheckboxWidgetState();
}

class _NoteCheckboxWidgetState extends State<NoteCheckboxWidget> {
  Color color = Colors.white;

  void onChanged(bool? newValue) => setState(() {
        if (newValue != null) {
          widget.data.value = newValue;
          debugPrint('CHECKBOX WIDGET: set value to ${widget.data.value}');

          if (widget.data.value) {
            callIfNotNull(widget.onTrue);
          } else {
            callIfNotNull(widget.onFalse);
          }
        }
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: paragraphDefaultFontSize,
      height: paragraphDefaultFontSize,
      child: Checkbox(
        value: widget.data.value,
        onChanged: onChanged,
        checkColor: Colors.grey,
        overlayColor: const MaterialStatePropertyAll(Colors.white),
      ),
    );
  }
}
