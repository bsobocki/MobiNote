import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';

void emptyFunction(int id) {}

class NoteParagraphPlaceholder extends NoteParagraph {
  NoteParagraphPlaceholder({
    super.key,
    required super.id,
    required super.widgetFactory,
    required this.onTap,
    super.reportFocusParagraph = emptyFunction,
    super.deleteParagraph = emptyFunction,
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
  String get text => '';

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
