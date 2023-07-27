import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_text_editor_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_list_element_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'definitions/widget_mode.dart';

class NoteListWidget extends NoteEditorWidget {
  NoteListData data;

  NoteListWidget({
    super.key,
    required super.id,
    required this.data,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.reportEditMode,
    super.removeFromParent,
  });

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  List<NoteListElementWidget> elements = [];
  NoteEditorWidgetFactory widgetFactory = NoteEditorWidgetFactory();
  int currDepth = 0;

  void setMode(WidgetMode mode) {
    debugPrint("List mode set to: $mode");
    widget.mode = mode;
    for (var elem in elements) {
      elem.setMode(mode);
    }
    if (mode == WidgetMode.edit) {
      if (elements.last.requestFocus != null) {
        elements.last.requestFocus!();
      } else {
        debugPrint('cannot request focus of the last element from list');
      }
    }
  }

  void resetView() => setState(() {
        setMode(WidgetMode.show);
      });

  void deleteElement(int id) {
    elements.removeWhere((elem) => elem.id == id);
    if (elements.isEmpty) {
      widget.removeFromParent?.call(widget.id);
    }
    setState(() {});
  }

  void _addNewElement({int prevElemId = -1, String initText = ''}) {
    int index = elements.length;
    if (exists(prevElemId)) {
      var prevElemIndex =
          elements.indexWhere((element) => element.id == prevElemId);
      if (exists(prevElemIndex)) {
        index = prevElemIndex + 1;
      }
    }

    NoteListElementData newElemData = NoteListElementData(
      id: -1,
      depth: currDepth,
      elemType: ElementType.checkbox,
    );
    newElemData.textEditorData = NoteTextEditorData(id: -1, text: initText);
    widget.data.addElement(newElemData);
    addElement(index, newElemData);
  }

  void addNewElement(int prevElemId, String initText) => setState(() {
        debugPrint('run _addElement($prevElemId, $initText)');
        _addNewElement(prevElemId: prevElemId, initText: initText);
      });

  void addElement(int index, NoteListElementData data) => elements.insert(
        index,
        NoteListElementWidget(
          id: widgetFactory.nextId,
          data: data,
          addNewListElement: addNewElement,
          onInteract: () => setState(() => setMode(WidgetMode.edit)),
          removeFromParent: deleteElement,
        ),
      );

  void addEmptyElement() => _addNewElement();

  void createWidgets() {
    if (widget.data.isListEmpty) {
      addEmptyElement();
    } else {
      int index = 0;
      for (var data in widget.data.elements!) {
        addElement(index++, data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setMode(WidgetMode.show);
    widget.setModeInState = (mode) => setState(() => setMode(mode));
    createWidgets();
  }

  @override
  void dispose() {
    widget.setDefaultCallbacks();
    super.dispose();
  }

  Widget createSelectedModeWidget() {
    return Column(children: [
      createShowModeWidget(),
      IconButton(
        onPressed: () => setState(addEmptyElement),
        icon: const Icon(
          Icons.add_circle_sharp,
          color: Colors.white,
        ),
      )
    ]);
  }

  Widget createShowModeWidget() {
    return IntrinsicHeight(
      child: Column(
        children: elements,
      ),
    );
  }

  Widget createListWidget() {
    switch (widget.mode) {
      case WidgetMode.selected:
        return createSelectedModeWidget();
      default:
        return createShowModeWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onLongPress: () {
          elements.last.requestFocus?.call();
          setState(() {
            setMode(WidgetMode.selected);
          });
        },
        child: createListWidget(),
      ),
    );
  }
}
