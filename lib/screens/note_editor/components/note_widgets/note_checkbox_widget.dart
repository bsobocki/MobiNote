import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteCheckboxWidget extends NoteEditorWidget {
  bool value = false;
  void Function()? onTrue;
  void Function()? onFalse;

  NoteCheckboxWidget(
      {super.key,
      required super.id,
      this.onTrue,
      this.onFalse,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.widgetType = 'checkbox'});

  @override
  State<NoteCheckboxWidget> createState() => _NoteCheckboxWidgetState();

  @override
  String get str => '{$id: checkbox: $value}';
}

class _NoteCheckboxWidgetState extends State<NoteCheckboxWidget> {
  Color color = Colors.white;

  void onChanged(bool? newValue) => setState(() {
        if (newValue != null) {
          widget.value = newValue;
          debugPrint('CHECKBOX WIDGET: set value to ${widget.value}');

          if (widget.value) {
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
      child: Checkbox(value: widget.value, onChanged: onChanged, checkColor: Colors.grey, overlayColor: const MaterialStatePropertyAll(Colors.white),),
    );
  }
}
