import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';

abstract class NoteEditorWidget extends StatefulWidget {
  final int id;
  WidgetMode mode;

  void Function()? onPressed;
  void Function()? onLongPress;
  void Function()? focusOnAction;
  void Function()? focusOffAction;
  void Function()? onInteract;
  void Function()? reportEditMode;
  void Function(int)? removeFromParent;

  void Function()? requestFocus;
  void Function(WidgetMode)? setModeInState;

  void setMode(WidgetMode mode) {
    if (setModeInState != null) {
      setModeInState!(mode);
    } else {
      debugPrint('setModeInState is null so need to chenge outside to $mode');
      this.mode = mode;
    }
  }

  void setDefaultCallbacks() {
    requestFocus = null;
    setModeInState = null;
  }

  NoteEditorWidget(
      {super.key,
      required this.id,
      this.onPressed,
      this.onLongPress,
      this.focusOnAction,
      this.focusOffAction,
      this.onInteract,
      this.reportEditMode,
      this.removeFromParent,
      this.mode = WidgetMode.show});
}
