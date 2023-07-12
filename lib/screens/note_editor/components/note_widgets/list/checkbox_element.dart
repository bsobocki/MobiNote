import 'package:flutter/material.dart';

class NoteCheckboxWidget extends StatefulWidget {
  const NoteCheckboxWidget({super.key});

  @override
  State<NoteCheckboxWidget> createState() => _NoteCheckboxWidgetState();
}

class _NoteCheckboxWidgetState extends State<NoteCheckboxWidget> {
  bool value = false;

  void onChanged(bool? newValue) {

  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(value: value, onChanged: onChanged);
  }
}
