import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraphs.dart';

int change = 1;
String lastNewText = "";

// ignore: must_be_immutable
class ContentEditor extends StatefulWidget {
  final Function(String value) onContentChange;
  final String initContent;
  final String initWidgets;
  late String Function() text;

  ContentEditor(
      {super.key,
      required this.initContent,
      required this.onContentChange,
      required this.initWidgets});

  String get widgets => '';

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  bool contentChanged = false;
  late NoteParagraphs paragraphs;
  int focusedParagraphId = -1;

  String text() => paragraphs.text();

  void setContentEditorState(void Function() fn) => setState(() {
      fn();
    });

  void onChange(String newText) => widget.onContentChange(newText);

  @override
  void initState() {
    super.initState();
    widget.text = text;
    paragraphs = NoteParagraphs(
        onChange: onChange,
        initContent: widget.initContent,
        setContentEditorState: setContentEditorState);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paragraphs.length,
      itemBuilder: (context, index) {
        return paragraphs.at(index);
      },
    );
  }
}
