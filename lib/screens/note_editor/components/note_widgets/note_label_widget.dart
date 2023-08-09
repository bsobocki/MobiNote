import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_label_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/theme/themes.dart';

class NoteLabelWidget extends NoteEditorWidget {
  @override
  final NoteLabelData data;

  NoteLabelWidget(
      {required super.id,
      required this.data,
      super.noteWidgetFactory,
      super.onContentChange,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.mode})
      : super(key: ValueKey('NoteLabelWidget_$id'));

  @override
  State<NoteLabelWidget> createState() => _NoteLabelWidgetState();
}

class _NoteLabelWidgetState extends State<NoteLabelWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Center(
        child: Text(
          widget.data.label,
          style: TextStyle(
            color: MobiNoteTheme.current.buttonBackgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: paragraphDefaultFontSize,
          ),
        ),
      ),
    );
  }
}
