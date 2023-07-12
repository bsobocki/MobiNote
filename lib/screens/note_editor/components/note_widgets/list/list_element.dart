import 'package:flutter/material.dart';

class NoteListElement extends StatefulWidget {
  const NoteListElement({super.key});

  @override
  State<NoteListElement> createState() => _NoteListElementState();
}


class _NoteListElementState extends State<NoteListElement> {
  List<Widget> widgets = [
    //Checkbox(value: value, onChanged: onChanged)
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widgets,
    );
  }
}
