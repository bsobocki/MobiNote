import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
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
  IdGenerator idGen = IdGenerator();
  int currDepth = 0;

  void setMode(WidgetMode mode) => setState(() {
        debugPrint("List mode set to: $mode");
        widget.mode = mode;
        for (var elem in widget.elements) {
          elem.setMode(mode);
        }
      });

  void _addElement({int prevElemId = -1, String initText = ''}) {
    int index = widget.elements.length;
    if (exists(prevElemId)) {
      debugPrint('===== ID: $prevElemId EXISTS!!!');
      var prevElemIndex =
          widget.elements.indexWhere((element) => element.id == prevElemId);
      if (exists(prevElemIndex)) {
        debugPrint('((((((((((((((((FOUND $prevElemId on $prevElemIndex))))))))))))))))');
        index = prevElemIndex + 1;
      }
    } else { 
      debugPrint('===== ID: $prevElemId DONT EXISTS!!!');
    }

int newId =  idGen.nextId;
    widget.elements.insert(
      index,
      NoteListElement(
        id: newId,
        depth: currDepth,
        elemType: ElementType.checkbox,
        onInteract: () => setMode(WidgetMode.edit),
        addNewElement: addElement,
        initText: initText,
      ),
    );

    debugPrint('================ Added ${newId} : "$initText" at position: $index');
  }

  void addElement(int prevElemId, String initText) => setState(() {
    debugPrint('run _addElement($prevElemId, $initText)');
        _addElement(prevElemId: prevElemId, initText: initText);
      });

  void addEmptyElement() => _addElement();

  @override
  void initState() {
    super.initState();
    addEmptyElement();
  }

  Widget createEditModeWidget() {
    return Column(children: [
      createShowModeWidget(),
      Center(
        child: IconButton(
          onPressed: addEmptyElement,
          icon: const Icon(Icons.add_circle_sharp),
        ),
      )
    ]);
  }

  Widget createShowModeWidget() {
    return IntrinsicHeight(
      child: Column(
        children: widget.elements,
      ),
    );
  }

  Widget createWidget() {
    switch (widget.mode) {
      case WidgetMode.edit:
        return createEditModeWidget();
      default:
        return createShowModeWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: createWidget());
  }
}
