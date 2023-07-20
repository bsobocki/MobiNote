import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_image_widget.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteParagraphWidget extends NoteParagraph {
  String widgetJSON;
  WidgetMode mode = WidgetMode.show;
  List<NoteEditorWidget> elements = [];

  NoteParagraphWidget(
      {required super.id,
      required super.reportFocusParagraph,
      required this.widgetJSON})
      : super(key: ValueKey("NoteParagraphWidget_$id")) {
    addWidget = _addWidget;
  }

  late void Function(NoteEditorWidget widget) addWidget;
  late void Function(WidgetMode mode)? setMode;
  void Function()? requestFocusInState;

  void requestFocus() {
    callIfNotNull(requestFocusInState);
  }

  void _addWidget(NoteEditorWidget widget) {
    debugPrint("noteparagraphwidget: add widget: $widget");
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
  late List<NoteEditorWidget> elements;
  late FocusNode focusNode;

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
        debugPrint("WIDGET PARAGRAPH: focus action is called!!!");
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
    noteEditorWidget.onTap = onTap;
    noteEditorWidget.focusOnAction = focusOnAction;
  }

  void addWidget(NoteEditorWidget noteEditorWidget) => setState(() {
        setCallbacks(noteEditorWidget);
        elements.add(noteEditorWidget);
        widget.elements.add(noteEditorWidget);
      });

  void onTap() {
    debugPrint("WIDGET PARAGRAPH: onTap action is called!!!");
    FocusScope.of(context).requestFocus(focusNode);
    if (focusNode.hasFocus) debugPrint( "WIDGET PARAGRAPH:  no focus to on maa...");
  }

  @override
  void initState() {
    super.initState();
    focusNode  = FocusNode();
    debugPrint("init state of note widget paragraph!!!");
    widget.addWidget = addWidget;
    for (var elem in widget.elements) {
      setCallbacks(elem);
    }
    elements = widget.elements;
    widget.setMode = setMode;
    widget.requestFocusInState = () => focusNode.requestFocus();
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
      onTap: onTap,
      child: Row(
        children: elements,
      ),
    );
  }

  void addImageWidget(String path) {
    elements.add(NoteImageWidget(path: path));
  }
}
