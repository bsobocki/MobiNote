import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';

abstract class NoteEditorWidget extends StatefulWidget {
  WidgetMode mode = WidgetMode.show;
  List<NoteEditorWidget> elements = [];

  void setMode(WidgetMode mode) {
    debugPrint('i changed mode to: ${mode == WidgetMode.edit ? 'edit' : 'other'}');
    this.mode = mode;
  }

  NoteEditorWidget({super.key});

  void addWidget(NoteEditorWidget widget) {
    elements.add(widget);
  }
}
