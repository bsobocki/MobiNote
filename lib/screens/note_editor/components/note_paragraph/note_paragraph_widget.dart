import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteParagraphWidget extends NoteParagraph {
  String widgetJSON;
  WidgetMode mode = WidgetMode.show;
  List<NoteEditorWidget> elements = [];

  NoteParagraphWidget(
      {required super.id,
      required super.noteWidgetFactory,
      required super.onContentChange,
      required super.reportFocusParagraph,
      required super.deleteParagraph,
      required this.widgetJSON})
      : super(key: ValueKey("NoteParagraphWidget_$id")) {
    setDefaultCallbacks();
  }

  late void Function(NoteEditorWidget) addWidget;
  late void Function(NoteWidgetData) addWidgetByData;
  void Function(WidgetMode)? setMode;
  void Function(int)? removeFromParent;

  void _addWidget(NoteEditorWidget widget) {
    elements.add(widget);
  }

  void _addWidgetByData(NoteWidgetData data) {
    var widget = noteWidgetFactory.create(data);
    elements.add(widget);
  }

  void _setMode(WidgetMode mode) {
    this.mode = mode;
  }

  @override
  void setDefaultCallbacks() {
    addWidget = _addWidget;
    addWidgetByData = _addWidgetByData;
    setMode = _setMode;
    requestFocusInState = null;
  }

  @override
  State<NoteParagraphWidget> createState() => _NoteParagraphWidgetState();

  @override
  int get rawLength => 1;

  @override
  String get str => '$id: $mode';

  @override
  String get content => '!$placeholder:$widgetTree';

  @override
  String get widgetTree {
    List<JSON> tree = [];
    for (var child in elements) {
      tree.add(child.data.json);
    }
    return jsonEncode(tree);
  }
}

class _NoteParagraphWidgetState extends State<NoteParagraphWidget> {
  IdGenerator idGen = IdGenerator();
  FocusNode focusNode = FocusNode();

  void setMode(WidgetMode mode) => setState(() {
        widget.mode = mode;
        for (var elem in widget.elements) {
          elem.setMode(mode);
        }
      });

  void focusOnAction() {
    widget.reportFocusParagraph(widget.id);
  }

  void focusAction() => setState(() {
        if (focusNode.hasFocus) {
          focusOnAction();
          widget.setMode!(WidgetMode.edit);
        } else {
          widget.setMode!(WidgetMode.show);
        }
      });

  void setCallbacks(NoteEditorWidget noteEditorWidget) {
    noteEditorWidget.focusOnAction =
        () => widget.reportFocusParagraph(widget.id);
    noteEditorWidget.onInteract = onInteract;
    noteEditorWidget.focusOnAction = focusOnAction;
    noteEditorWidget.removeFromParent = removeWidget;
    noteEditorWidget.setParentState = setState;
  }

  void addWidget(NoteEditorWidget noteEditorWidget) => setState(() {
        setCallbacks(noteEditorWidget);
        widget.elements.add(noteEditorWidget);
      });

  void addWidgetByData(NoteWidgetData data) {
    var newWidget = widget.noteWidgetFactory.create(data);
    setCallbacks(newWidget);
    setState(() {
      widget.elements.add(newWidget);
    });
  }

  void onInteract() {
    widget.reportFocusParagraph(widget.id);
    FocusScope.of(context).requestFocus(focusNode);
  }

  void removeWidget(int widgetId) {
    widget.elements.removeWhere((element) => element.id == widgetId);
    if (widget.elements.isEmpty) {
      FocusScope.of(context).unfocus();
      widget.deleteParagraph(widget.id);
    } else {
      setState(() {});
    }
  }

  void addSetStateToWidgetMethods() {
    widget.addWidget = addWidget;
    widget.addWidgetByData = addWidgetByData;
  }

  @override
  void initState() {
    super.initState();
    widget.stateCounter++;
    addSetStateToWidgetMethods();
    for (var elem in widget.elements) {
      setCallbacks(elem);
    }
    widget.setMode = setMode;
    widget.requestFocusInState =
        () => FocusScope.of(context).requestFocus(focusNode);
    focusNode.addListener(focusAction);
  }

  @override
  void dispose() {
    widget.stateCounter--;
    if (widget.removingState) {
      widget.setDefaultCallbacks();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onInteract();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 4.0,
          right: 4.0,
        ),
        child: Row(
          children: widget.elements,
        ),
      ),
    );
  }
}
