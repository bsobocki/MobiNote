import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/all_widget_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';

abstract class NoteEditorWidget extends StatefulWidget {
  NoteEditorWidgetFactory? noteWidgetFactory;
  final int id;
  WidgetMode mode;
  int stateCounter = 0;
  bool get removingState => stateCounter == 0;

  void Function()? onContentChange;
  void Function()? onPressed;
  void Function()? onLongPress;
  void Function()? focusOnAction;
  void Function()? focusOffAction;
  void Function()? onInteract;
  void Function()? reportEditMode;
  void Function(int)? removeFromParent;
  void Function(Function())? setParentState;

  void Function()? forceSetState;
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
    forceSetState = null;
  }

  NoteWidgetData get data;

  NoteEditorWidget(
      {super.key,
      required this.id,
      this.onContentChange,
      this.noteWidgetFactory,
      this.onPressed,
      this.onLongPress,
      this.focusOnAction,
      this.focusOffAction,
      this.onInteract,
      this.reportEditMode,
      this.removeFromParent,
      this.setParentState,
      this.mode = WidgetMode.show});
}
