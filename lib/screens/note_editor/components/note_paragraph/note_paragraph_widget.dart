import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_image_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

// ignore: must_be_immutable
class NoteParagraphWidget extends NoteParagraph {
  String widgetJSON;
  WidgetMode mode = WidgetMode.show;
  List<NoteEditorWidget> elements = [];
  NoteEditorWidgetFactory widgetFactory = NoteEditorWidgetFactory();

  NoteParagraphWidget(
      {required super.id,
      required super.reportFocusParagraph,
      required super.deleteParagraph,
      required this.widgetJSON})
      : super(key: ValueKey("NoteParagraphWidget_$id")) {
    addWidget = _addWidget;
    addWidgetByType = _addWidgetByType;
  }

  late void Function(NoteEditorWidget widget) addWidget;
  late Future<void> Function(String type) addWidgetByType;
  void Function(WidgetMode mode)? setMode;
  void Function(int)? removeFromParent;

  void _addWidget(NoteEditorWidget widget) {
    debugPrint("noteparagraphwidget: add widget: $widget");
    elements.add(widget);
  }

  Future<void> _addWidgetByType(String type) async {
    var widget = await widgetFactory.create(type);
    debugPrint("noteparagraphwidget: add widget by type: $type");
    elements.add(widget);
  }

  @override
  State<NoteParagraphWidget> createState() => _NoteParagraphWidgetState();

  @override
  int get rawLength => 1;

  @override
  String get str => '$id: $mode';

  @override
  String get text => '![widget:$id]';

  @override
  String get widgetTree => '';
}

class _NoteParagraphWidgetState extends State<NoteParagraphWidget> {
  IdGenerator idGen = IdGenerator();
  FocusNode focusNode = FocusNode();

  void setMode(WidgetMode mode) => setState(() {
        debugPrint(
            "mode set to: ${mode == WidgetMode.edit ? 'edit' : 'other'}");
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
  }

  void addWidget(NoteEditorWidget noteEditorWidget) => setState(() {
        setCallbacks(noteEditorWidget);
        widget.elements.add(noteEditorWidget);
      });

  Future<void> addWidgetByType(String type) async {
    var newWidget = await widget.widgetFactory.create(type);
    debugPrint("noteparagraphwidget: add widget: $type");
    setCallbacks(newWidget);
    setState(() {
      widget.elements.add(newWidget);
    });
  }

  void onInteract() {
    debugPrint("WIDGET PARAGRAPH: ON INTERACT");
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
    widget.addWidgetByType = addWidgetByType;
  }

  @override
  void initState() {
    super.initState();
    debugPrint("init state of note widget paragraph!!!");
    widget.addWidget = addWidget;
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
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onInteract,
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
