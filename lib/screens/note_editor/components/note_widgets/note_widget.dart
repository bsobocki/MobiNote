import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';

abstract class NoteEditorWidget extends StatefulWidget{
  WidgetMode mode = WidgetMode.edit;
  List<NoteEditorWidget> elements = [];

  NoteEditorWidget({super.key});

  void addWidget(NoteEditorWidget widget) {
    elements.add(widget);
  }
}