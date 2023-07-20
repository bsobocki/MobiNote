import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';

abstract class NoteEditorWidget extends StatefulWidget {
  WidgetMode mode = WidgetMode.show;
  List<NoteEditorWidget> elements = [];
  void Function()? focusOnAction;
  void Function()? focusOffAction;
  void Function()? onTap;
  void Function(WidgetMode)? setModeInState;

  void setMode(WidgetMode mode) {
    if (setModeInState != null) {
      setModeInState!(mode);
    }
  }

  NoteEditorWidget({super.key});

  void addWidget(NoteEditorWidget widget) {
    elements.add(widget);
  }
}
