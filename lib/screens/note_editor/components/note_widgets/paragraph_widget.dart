import 'package:flutter/material.dart';

class NoteParagraphWidget extends StatefulWidget {
  String widgetJSON;
  final int id;

  NoteParagraphWidget({required this.id, required this.widgetJSON})
      : super(key: ValueKey("NoteParagraphWidget_$id"));

  @override
  State<NoteParagraphWidget> createState() => _NoteParagraphWidgetState();
}

class _NoteParagraphWidgetState extends State<NoteParagraphWidget> {
  List<Widget> elements = [];




  @override
  Widget build(BuildContext context) {
    return Row();
  }
}
