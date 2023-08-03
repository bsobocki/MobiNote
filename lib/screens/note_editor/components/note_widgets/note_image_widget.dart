import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_image_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';
import 'package:mobi_note/screens/note_editor/helpers/images.dart';
import 'package:mobi_note/screens/theme/themes.dart';

import 'definitions/widget_mode.dart';

const double resizeLimit = 20;

class NoteImageWidget extends NoteEditorWidget {
  NoteImageData data;

  NoteImageWidget({
    super.key,
    required super.id,
    required this.data,
    super.onContentChange,
    super.focusOffAction,
    super.focusOnAction,
    super.onInteract,
    super.removeFromParent,
    super.mode,
  });

  @override
  State<NoteImageWidget> createState() => _NoteImageWidgetState();
}

class _NoteImageWidgetState extends State<NoteImageWidget> {
  final GlobalKey imageKey = GlobalKey();
  Size? _size;
  double sizeRatio = 1.0;

  void setMode(WidgetMode mode) => setState(() {
        debugPrint("Image mode set to: $mode");
        widget.mode = mode;
        trytoSaveSize();
      });

  BoxDecoration getBoxDecorationForMode(WidgetMode mode) {
    debugPrint("building image in mode: $mode");
    switch (mode) {
      case WidgetMode.edit:
      case WidgetMode.selected:
        return BoxDecoration(
            border: Border.all(color: MobiNoteTheme.current.textColor, width: 4.0));
      default:
        return const BoxDecoration(
          border: Border(),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.stateCounter++;
    widget.setModeInState = setMode;
    if (widget.data.width != -1 && widget.data.height != -1) {
      _size = Size(widget.data.width, widget.data.height);
    }
  }

  @override
  void dispose() {
    widget.stateCounter--;
    if (widget.removingState) widget.setDefaultCallbacks();
    super.dispose();
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
      alignment: Alignment.topLeft,
      width: size?.width,
      height: size?.height,
      decoration: getBoxDecorationForMode(widget.mode),
      child: Opacity(
        opacity: opacity,
        child: Container(
          color: MobiNoteTheme.current.textColor,
          child: Image.file(
            key: imageKey,
            File(widget.data.path!),
          ),
        ),
      ),
    );
  }

  Widget showModeWidget() {
    return getWidget();
  }

  void trytoSaveSize() {
    var renderObject =
        imageKey.currentContext?.findRenderObject() as RenderBox?;
    _size = renderObject?.size;
    if (_size != null) {
      sizeRatio = _size!.width / _size!.height;
    }
  }

  Size? get size {
    if (_size == null) {
      trytoSaveSize();
    }
    return _size;
  }

  set size(Size? newSize) {
    _size = newSize;
    widget.data.width = newSize?.width ?? widget.data.width;
    widget.data.height = newSize?.height ?? widget.data.height;
    widget.onContentChange?.call();
  }

  Widget editModeWidget() {
    Size? imgSize = size ?? const Size(0, 0);
    return Container(
      width: size?.width,
      height: size?.height,
      child: Stack(children: [
        getWidget(),
        Positioned(
            bottom: 0,
            left: imgSize.width / 2,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                debugPrint('details: $details');
                setState(() {
                  if (size != null) {
                    double movingDelta = details.delta.dy;
                    double newWidth = size!.width + movingDelta * sizeRatio;
                    double newHeight = size!.height + movingDelta;
                    if (newWidth > resizeLimit && newHeight > resizeLimit) {
                      size = Size(newWidth, newHeight);
                    }
                  }
                });
              },
              child: Icon(
                Icons.arrow_circle_up,
                color: MobiNoteTheme.current.textColor,
              ),
            )),
      ]),
    );
  }

  Widget selectedModeWidget() {
    return Stack(
      children: [
        getWidget(opacity: 0.8),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  widget.removeFromParent?.call(widget.id);
                  widget.onContentChange?.call();
                },
                icon: Icon(
                  Icons.disabled_by_default_rounded,
                  color: MobiNoteTheme.current.textColor,
                ),
              ),
              IconButton(
                onPressed: () async {
                  String newPath = await chooseImage();
                  if (newPath.isNotEmpty) {
                    setState(() {
                      widget.data.path = newPath;
                    });
                    widget.onContentChange?.call();
                  }
                },
                icon: Icon(
                  Icons.edit_square,
                  color: MobiNoteTheme.current.textColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
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
