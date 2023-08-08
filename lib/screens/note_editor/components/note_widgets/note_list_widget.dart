import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_checkbox_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_icon_button_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_text_editor_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_icon_button_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_list_element_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/theme/themes.dart';
import 'definitions/widget_mode.dart';

class NoteListWidget extends NoteEditorWidget {
  NoteListData data;

  NoteListWidget({
    super.key,
    required super.id,
    required this.data,
    required super.noteWidgetFactory,
    super.onContentChange,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.reportEditMode,
    super.removeFromParent,
  }) {
    noteWidgetFactory ??= NoteEditorWidgetFactory();
  }

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  List<NoteListElementWidget> elements = [];
  int currDepth = 0;

  void setNumbers(int startIndex) {
    debugPrint('NoteListWidget:  setNumbers!!!!!!');
    for (int i = startIndex; i < elements.length; i++) {
      elements[i].data.number = i + 1;
      if (widget.data.elemType == ElementType.number) {
        if (elements[i].forceSetState == null) {
          debugPrint('WHAAAAAAAAAAAAAAAAAAAATTTTT');
        }
        elements[i].forceSetState?.call();
      } else {
        debugPrint(
            '************************element type is: ${widget.data.elemType}');
      }
    }
    widget.onContentChange?.call();
  }

  void setElementType(ElementType type) => setState(() {
        widget.data.elemType = type;
        for (var elem in elements) {
          elem.data.elemType = type;
        }
        setMode(WidgetMode.edit);
        widget.onContentChange?.call();
      });

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

  void onLongPress() {
    WidgetMode newMode = WidgetMode.selected;
    if (widget.mode == WidgetMode.selected) {
      newMode = WidgetMode.edit;
    }
    setState(() {
      setMode(newMode);
    });
  }

  void resetView() => setState(() {
        setMode(WidgetMode.show);
      });

  void deleteElement(int id) {
    var index = elements.indexWhere((elem) => elem.id == id);
    if (exists(index)) {
      elements.removeAt(index);
      widget.data.elements!.removeAt(index);
      widget.onContentChange?.call();
    }
    if (elements.isEmpty) {
      widget.removeFromParent?.call(widget.id);
    } else {
      setNumbers(index);
      setState(() {});
    }
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
      number: index + 1,
      elemType: widget.data.elemType,
      checkboxData: NoteCheckboxData(id: -1, value: false),
      textEditorData: NoteTextEditorData(id: -1, text: initText),
    );
    widget.data.addElementAt(index, newElemData);
    addElementFromData(index, newElemData);
  }

  void addElementFromData(int index, NoteListElementData data) {
    elements.insert(
      index,
      NoteListElementWidget(
        id: widget.noteWidgetFactory!.nextId('list_element'),
        onContentChange: widget.onContentChange,
        number: index + 1,
        data: data,
        addNewListElement: addNewElement,
        removeFromParent: deleteElement,
        onInteract: () => setState(() => setMode(WidgetMode.edit)),
        onLongPress: onLongPress,
        mode: widget.mode,
        noteWidgetFactory: widget.noteWidgetFactory,
      ),
    );
    setNumbers(index + 1);
  }

  void addNewElement(int prevElemId, String initText) => setState(() {
        debugPrint('run _addElement($prevElemId, $initText)');
        _addNewElement(prevElemId: prevElemId, initText: initText);
        debugPrint('addNewElement: set state!!!!!');
      });

  void addEmptyElement() => _addNewElement();

  void createWidgets() {
    if (widget.data.isListEmpty) {
      addEmptyElement();
    } else {
      int index = 0;
      for (var data in widget.data.elements!) {
        addElementFromData(index++, data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.stateCounter++;
    setMode(WidgetMode.show);
    widget.setModeInState = (mode) => setState(() => setMode(mode));
    createWidgets();
    widget.forceSetState = () => setState(() {});
  }

  @override
  void dispose() {
    widget.setDefaultCallbacks();
    super.dispose();
  }

  Widget get elemModeSelectionBar {
    return Container(
      color: MobiNoteTheme.current.barColor,
      child: Row(
        children: [
          IconButton(
            onPressed: () => setElementType(ElementType.checkbox),
            icon: const Icon(Icons.check_box_rounded),
          ),
          IconButton(
            onPressed: () => setElementType(ElementType.number),
            icon: const Icon(Icons.format_list_numbered),
          ),
          IconButton(
            onPressed: () => setElementType(ElementType.marks),
            icon: const Icon(Icons.format_list_bulleted_outlined),
          ),
          IconButton(
            onPressed: () => setElementType(ElementType.custom),
            icon: const Icon(Icons.location_history),
          ),
          IconButton(
            onPressed: () => setElementType(ElementType.counter),
            icon: const Icon(Icons.numbers_rounded),
          ),
        ],
      ),
    );
  }

  Widget createSelectedModeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        elemModeSelectionBar,
        showModeWidget,
        widget.noteWidgetFactory?.create(
          NoteIconButtonData(
            id: -1,
            paddingTop: 6.0,
            icon: Icons.add_circle_sharp,
            color: MobiNoteTheme.current.textColor,
          ),
        ) as NoteIconButtonWidget
          ..onPressed = () => setState(addEmptyElement),
      ],
    );
  }

  Widget get showModeWidget {
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
        return showModeWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onLongPress: onLongPress,
        child: createListWidget(),
      ),
    );
  }
}
