import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteImageWidget extends NoteEditorWidget {
  NoteImageWidget({super.key, required this.path});
  final String path;

  @override
  State<NoteImageWidget> createState() => _NoteImageWidgetState();
}

class _NoteImageWidgetState extends State<NoteImageWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.file(File(widget.path), width: 100, height: 100),
    );
  }
}