import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph.dart';

class NoteParagraphWidget extends NoteParagraph {
  String widgetJSON;

  NoteParagraphWidget(
      {required super.id,
      required super.reportFocusParagraph,
      required this.widgetJSON})
      : super(key: ValueKey("NoteParagraphWidget_$id"));

  @override
  State<NoteParagraphWidget> createState() => _NoteParagraphWidgetState();
}

class _NoteParagraphWidgetState extends State<NoteParagraphWidget> {
  List<Widget> elements = [];
  FocusNode focusNode = FocusNode();

  void foucusAction() {
    if (focusNode.hasFocus) {
      widget.reportFocusParagraph(widget.id);
      
    } else {

    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row();
  }
}
