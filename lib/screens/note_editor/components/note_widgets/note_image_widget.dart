import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/note_editor/helpers/images.dart';

import 'definitions/widget_mode.dart';

class NoteImageWidget extends NoteEditorWidget {
  NoteImageWidget(
      {super.key, required this.path, required super.id, super.type = 'image'});
  String path;

  @override
  State<NoteImageWidget> createState() => _NoteImageWidgetState();
}

class _NoteImageWidgetState extends State<NoteImageWidget> {
  void setMode(WidgetMode mode) => setState(() {
        debugPrint("Image mode set to: $mode");
        widget.mode = mode;
        for (var elem in widget.elements) {
          elem.setMode(mode);
        }
      });

  BoxDecoration getBoxDecorationForMode(WidgetMode mode) {
    debugPrint("building image in mode: $mode");
    switch (mode) {
      case WidgetMode.edit:
      case WidgetMode.selected:
        return BoxDecoration(
            border: Border.all(color: Colors.white, width: 4.0),
            color: Colors.white);
      default:
        return const BoxDecoration(border: Border(), color: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.setModeInState = setMode;
  }

  Widget getWidgetBasedOnMode() {
    switch (widget.mode) {
      case WidgetMode.edit:
        return editModeWidget();
      case WidgetMode.selected:
        return selectedModeWidget();
      default:
        return showModeWidget();
    }
  }

  Widget getWidget({double opacity = 1.0}) {
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
    return getWidget();
  }

  Widget editModeWidget() {
    return getWidget();
  }

  Widget selectedModeWidget() {
    return Stack(children: [
      getWidget(opacity: 0.8),
      Center(
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (widget.removeFromParent != null) {
                    widget.removeFromParent!(widget.id);
                  }
                },
                icon: const Icon(
                  Icons.disabled_by_default_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  String newPath = await chooseImage();
                  if (newPath.isNotEmpty) {
                    setState(() {
                      widget.path = newPath;
                    });
                  }
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
        onDoubleTap: () {
          callIfNotNull(widget.onInteract);
          setMode(WidgetMode.edit);
        },
        onLongPress: () {
          setMode(WidgetMode.selected);
          callIfNotNull(widget.onInteract);
        },
        child: getWidgetBasedOnMode(),
      ),
    );
  }
}
