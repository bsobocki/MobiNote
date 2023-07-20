import 'package:flutter/material.dart';

abstract class NoteParagraph extends StatefulWidget {
  final int id;
  void Function(int id) reportFocusParagraph;

  NoteParagraph({
    super.key,
    required this.id,
    required this.reportFocusParagraph,
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
