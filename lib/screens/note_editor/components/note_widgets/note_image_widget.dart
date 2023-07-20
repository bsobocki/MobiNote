import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

import 'definitions/widget_mode.dart';

class NoteImageWidget extends NoteEditorWidget {
  NoteImageWidget({super.key, required this.path});
  final String path;

  @override
  State<NoteImageWidget> createState() => _NoteImageWidgetState();
}

class _NoteImageWidgetState extends State<NoteImageWidget> {

  void setMode(WidgetMode mode) => setState(() {
        debugPrint(
            "Image mode set to: ${mode == WidgetMode.edit ? 'edit' : 'other'}");
        widget.mode = mode;
        for (var elem in widget.elements) {
          elem.setMode(mode);
        }
      });

  BoxDecoration getBoxDecorationForMode(WidgetMode mode) {
    debugPrint(
        "building image in mode: ${mode == WidgetMode.edit ? 'edit' : 'other'}");
    if (mode == WidgetMode.edit) {
      return BoxDecoration(border: Border.all(color: Colors.white));
    }
    return BoxDecoration(
        border: Border.all(color: Colors.grey[900]!, width: 2.0));
  }

  @override
  void initState() {
    super.initState();
    widget.setModeInState = setMode;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          callIfNotNull(widget.onTap);
          setMode(WidgetMode.edit);
        },
        child: Container(
          decoration: getBoxDecorationForMode(widget.mode),
          child: Image.file(File(widget.path)),
        ),
      ),
    );
  }
}
