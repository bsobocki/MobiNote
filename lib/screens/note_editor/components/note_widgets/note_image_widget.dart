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
      return BoxDecoration(border: Border.all(color: Colors.white, width: 4.0), color: Colors.white);
    }
    return const BoxDecoration(border: Border(), color: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    widget.setModeInState = setMode;
  }

  Widget getWidgetBasedOnMode() {
    if (widget.mode == WidgetMode.edit) return editModeWidget();
    return showModeWidget();
  }

  Widget getWidget(double opacity) {
    return Container(
      decoration: getBoxDecorationForMode(widget.mode),
      child: Opacity(
        opacity: opacity,
        child: Image.file(
          File(widget.path),
        ),
      ),
    );
  }

  Widget showModeWidget() {
    return getWidget(1.0);
  }

  Widget editModeWidget() {
    return Stack(children: [
      getWidget(0.8),
      Center(
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  debugPrint('need to remove!!!!!!!!');
                },
                icon: const Icon(
                  Icons.disabled_by_default_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  debugPrint('EDIT THIS IMAGE!!! ');
                },
                icon: const Icon(
                  Icons.edit_square,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          callIfNotNull(widget.onTap);
          setMode(WidgetMode.edit);
        },
        child: getWidgetBasedOnMode(),
      ),
    );
  }
}
