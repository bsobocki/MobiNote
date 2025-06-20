import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';

// ignore: must_be_immutable
abstract class NoteParagraph extends StatefulWidget {
  int stateCounter = 0;
  bool get removingState => stateCounter == 0;

  NoteEditorWidgetFactory noteWidgetFactory;
  final int id;
  void Function() onContentChange;
  void Function(int) reportFocusParagraph;
  void Function(int) deleteParagraph;

  void Function()? requestFocusInState;

  void requestFocus() {
    if (requestFocusInState != null) {
      requestFocusInState!();
    }
  }

  void setDefaultCallbacks() {
    requestFocusInState = null;
  }

  NoteParagraph({
    super.key,
    required this.id,
    required this.noteWidgetFactory,
    required this.onContentChange,
    required this.reportFocusParagraph,
    required this.deleteParagraph,
  });

  String get content;
  int get rawLength;
  String get widgetTree;
  String get str;
}
