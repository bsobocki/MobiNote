import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteParagraphWidget extends NoteParagraph {
  String widgetJSON;
  final List<NoteEditorWidget> elements;

  NoteParagraphWidget(
      {required super.id,
      required super.reportFocusParagraph,
      required this.widgetJSON,
      this.elements = const []})
      : super(key: ValueKey("NoteParagraphWidget_$id"));

  @override
  State<NoteParagraphWidget> createState() => _NoteParagraphWidgetState();
}

class _NoteParagraphWidgetState extends State<NoteParagraphWidget> {
  late List<Widget> elements;
  FocusNode focusNode = FocusNode();

  void foucusAction() {
    if (focusNode.hasFocus) {
      widget.reportFocusParagraph(widget.id);
    } else {}
  }

  @override
  void initState() {
    super.initState();
    elements = widget.elements;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: elements,);
  }
}
