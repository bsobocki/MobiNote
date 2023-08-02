import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/definitions/unicodes.dart';
import 'package:mobi_note/logic/note_editor/text_editor/parser/unicode_marked_text_parser.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

// ignore: must_be_immutable
class NoteParagraphWidget extends NoteParagraph {
  String widgetJSON;
  WidgetMode mode = WidgetMode.show;
  List<NoteEditorWidget> elements = [];
  NoteEditorWidgetFactory widgetFactory = NoteEditorWidgetFactory();

  NoteParagraphWidget(
      {required super.id,
      required super.widgetFactory,
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

  String Function()? widgetTreeFromState;

  void _addWidget(NoteEditorWidget widget) {
    debugPrint("noteparagraphwidget: add widget: $widget");
    elements.add(widget);
  }

  void _addWidgetByData(NoteWidgetData data) {
    var widget = widgetFactory.create(data);
    debugPrint("noteparagraphwidget: add widget by type: ${data.type}");
    elements.add(widget);
  }

  void _setMode(WidgetMode mode) {
    this.mode = mode;
  }

  void setDefaultCallbacks() {
    addWidget = _addWidget;
    addWidgetByData = _addWidgetByData;
    setMode = _setMode;
    requestFocusInState = null;
    widgetTreeFromState = () => '';
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
  String get widgetTree => widgetTreeFromState!();
}

class _NoteParagraphWidgetState extends State<NoteParagraphWidget> {
  IdGenerator idGen = IdGenerator();
  FocusNode focusNode = FocusNode();

  void setMode(WidgetMode mode) => setState(() {
        debugPrint("mode set to: $mode");
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
          debugPrint("WIDGET PARAGRAPH: focus action is called!!!");
          focusOnAction();
          widget.setMode!(WidgetMode.edit);
        } else {
          debugPrint("WIDGET PARAGRAPH: UNFOCUS action is called!!!");
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
    var newWidget = widget.widgetFactory.create(data);
    debugPrint(
        "---------+++++++++++ noteparagraphwidget: add widget: ${data.type}");
    setCallbacks(newWidget);
    setState(() {
      widget.elements.add(newWidget);
    });
  }

  void onInteract() {
    debugPrint("WIDGET PARAGRAPH: ON INTERACT");
    widget.reportFocusParagraph(widget.id);
    FocusScope.of(context).requestFocus(focusNode);
    debugPrint("WIDGET PARAGRAPH: HAS FOCUS? ${focusNode.hasFocus}");
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

  String widgetTree() {
    List<JSON> tree = [];
    for (var child in widget.elements) {
      tree.add(child.data.json);
    }
    return jsonEncode(tree);
  }

  @override
  void initState() {
    super.initState();
    widget.stateCounter++;
    debugPrint("init state of note widget paragraph!!!");
    addSetStateToWidgetMethods();
    for (var elem in widget.elements) {
      setCallbacks(elem);
    }
    widget.widgetTreeFromState = widgetTree;
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
        debugPrint('gesture detector!!!!!!!!!!!!!!!');
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
