import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_label_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteLabelWidget extends NoteEditorWidget {
  final NoteLabelData data;

  NoteLabelWidget({
    super.key,
    required super.id,
    required this.data,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.removeFromParent,
  });

  @override
  State<NoteLabelWidget> createState() => _NoteLabelWidgetState();
}

class _NoteLabelWidgetState extends State<NoteLabelWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: paragraphDefaultFontSize,
      height: paragraphDefaultFontSize,
      child: Text(
        widget.data.label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: paragraphDefaultFontSize,
        ),
      ),
    );
  }
}
