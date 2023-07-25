import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/screens/note_editor/components/note_list/list_element.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import '../note_widgets/definitions/widget_mode.dart';

class NoteListWidget extends NoteEditorWidget {
  NoteListWidget({
    super.key,
    required super.id,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.removeFromParent,
    super.widgetType = 'list',
  });

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  IdGenerator idGen = IdGenerator(currId: 1);
  int currDepth = 0;

  void addElement() => setState(() {
        widget.elements.add(
          NoteListElement(
            id: idGen.nextId,
            depth: currDepth,
            elemType: ElementType.checkbox,
          ),
        );
      });

  @override
  void initState() {
    super.initState();
    widget.elements = [
      NoteListElement(
        id: 0,
        depth: 0,
        elemType: ElementType.checkbox,
      )
    ];
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
