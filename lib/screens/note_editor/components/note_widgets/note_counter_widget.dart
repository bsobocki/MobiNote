import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_counter_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteCounterWidget extends NoteEditorWidget {
  NoteCounterData data;

  NoteCounterWidget(
      {super.key,
      required super.id,
      required this.data,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.mode});

  @override
  State<NoteCounterWidget> createState() => _NoteCounterWidgetState();
}

class _NoteCounterWidgetState extends State<NoteCounterWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() {
        widget.data.count++;
      }),
      child: Text('${widget.data.count} / ${widget.data.targetValue}'),
    );
  }
}
