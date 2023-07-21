import 'package:flutter/material.dart';

abstract class NoteParagraph extends StatefulWidget {
  final int id;
  void Function(int) reportFocusParagraph;
  void Function(int) deleteParagraph;

  NoteParagraph({
    super.key,
    required this.id,
    required this.reportFocusParagraph,
    required this.deleteParagraph,
  });

  String get text;
  int get rawLength;
  String get widgetTree;
  String get str;

  @override
  State<NoteParagraph> createState() => _NoteParagraphState();
}

class _NoteParagraphState extends State<NoteParagraph> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
