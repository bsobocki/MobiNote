import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_icon_button_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/theme/themes.dart';

class NoteIconButtonWidget extends NoteEditorWidget {
  @override
  final NoteIconButtonData data;

  NoteIconButtonWidget(
      {super.key,
      required super.id,
      required this.data,
      super.onContentChange,
      super.onPressed,
      super.onLongPress,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.mode});

  @override
  State<NoteIconButtonWidget> createState() => _NoteLabelWidgetState();
}

class _NoteLabelWidgetState extends State<NoteIconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.data.paddingLeft,
        right: widget.data.paddingRight,
        top: widget.data.paddingTop,
        bottom: widget.data.paddingBottom,
      ),
      child: ButtonTheme(
        minWidth: 4.0,
        padding: EdgeInsets.zero,
        child: IconButton(
          padding: const EdgeInsets.all(1.0),
          constraints: const BoxConstraints(),
          onPressed: widget.onPressed,
          icon: Icon(
            widget.data.icon,
            color: widget.data.color ?? MobiNoteTheme.current.buttonBackgroundColor,
          ),
        ),
      ),
    );
  }
}
