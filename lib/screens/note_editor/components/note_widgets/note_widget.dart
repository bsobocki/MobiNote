import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';

abstract class NoteEditorWidget extends StatefulWidget {
  final int id;
  WidgetMode mode = WidgetMode.show;

  void Function()? focusOnAction;
  void Function()? focusOffAction;
  void Function()? onInteract;
  void Function(int)? removeFromParent;

  void Function(WidgetMode)? setModeInState;

  void setMode(WidgetMode mode) {
    if (setModeInState != null) {
      setModeInState!(mode);
    }
  }

  NoteEditorWidget(
      {super.key,
      required this.id,
      this.focusOnAction,
      this.focusOffAction,
      this.onInteract,
      this.removeFromParent});
}
