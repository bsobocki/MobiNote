import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_label_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteLabelWidget extends NoteEditorWidget {
  final NoteLabelData data;

  NoteLabelWidget(
      {required super.id,
      required this.data,
      required super.widgetFactory,
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
    debugPrint('NoteLabelWidget: build!!!!');
    return Text(
      widget.data.label,
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: paragraphDefaultFontSize,
      ),
    );
  }
}
