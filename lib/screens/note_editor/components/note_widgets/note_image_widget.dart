import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

import 'definitions/widget_mode.dart';

class NoteImageWidget extends NoteEditorWidget {
  NoteImageWidget({super.key, required this.path});
  final String path;

  @override
  State<NoteImageWidget> createState() => _NoteImageWidgetState();
}

class _NoteImageWidgetState extends State<NoteImageWidget> {
  BoxDecoration getBoxDecorationForMode(WidgetMode mode) {
    debugPrint("building image in mode: ${mode == WidgetMode.edit? 'edit' : 'other'}");
    if (mode == WidgetMode.edit) {
      return BoxDecoration(border: Border.all(color: Colors.white));
    } 
    return BoxDecoration(border: Border.all(color: Colors.grey[900]!));
  }

  @override
  Widget build(BuildContext context) {
    var image = Image.file(File(widget.path));
    return Expanded(
        child: Container(
      decoration: getBoxDecorationForMode(widget.mode),
      child: image,
    ));
  }
}
