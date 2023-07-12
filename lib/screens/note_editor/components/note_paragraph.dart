import 'package:flutter/material.dart';

class NoteParagraph extends StatefulWidget {
  final int id;
  void Function(int id) reportFocusParagraph;

  NoteParagraph({super.key, required this.id, required this.reportFocusParagraph});
  String get text => '';
  int get rawLength => 0;
  String get widgets => '';
  String get str => '$id: ';

  @override
  State<NoteParagraph> createState() => _NoteParagraphState();
}

class _NoteParagraphState extends State<NoteParagraph> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
