import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_icon_button_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteIconButtonWidget extends NoteEditorWidget {
  final NoteIconButtonData data;

  void Function()? onPressed;

  NoteIconButtonWidget({
    super.key,
    required super.id,
    required this.data,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.removeFromParent,
  });

  @override
  State<NoteIconButtonWidget> createState() => _NoteLabelWidgetState();
}

class _NoteLabelWidgetState extends State<NoteIconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed,
      icon: Icon(widget.data.icon),
    );
  }
}
