import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/empty_functions.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';

class NoteParagraphPlaceholder extends NoteParagraph {
  NoteParagraphPlaceholder({
    super.key,
    required super.id,
    required super.noteWidgetFactory,
    required this.onTap,
    super.onContentChange = emptyFunction,
    super.reportFocusParagraph = emptyFunctionInt,
    super.deleteParagraph = emptyFunctionInt,
  });

  void Function() onTap;

  @override
  State<NoteParagraphPlaceholder> createState() =>
      _NoteParagraphPlaceholderState();

  @override
  int get rawLength => 0;

  @override
  String get str => '$id: placeholder';

  @override
  String get content => '';

  @override
  String get widgetTree => '';
}

class _NoteParagraphPlaceholderState extends State<NoteParagraphPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: MediaQuery.of(context).size.height),
    );
  }
}
