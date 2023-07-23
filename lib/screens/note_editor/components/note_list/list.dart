import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_list/list_element.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import '../note_widgets/definitions/widget_mode.dart';

class NoteListWidget extends NoteEditorWidget {
  NoteListWidget({super.key, required super.id, super.type = 'list'});

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  NoteEditorWidgetFactory widgetFactory = NoteEditorWidgetFactory(startId: 1);

  void addElement() async {
    NoteListElement elem =
        await widgetFactory.create('list_element') as NoteListElement;
    setState(() {
      widget.elements.add(elem);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.elements = [NoteListElement(id: 0)];
  }

  Widget createEditMode() {
    return Column(children: []);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IntrinsicHeight(
        child: Column(
          children: widget.elements,
        ),
      ),
    );
  }
}
