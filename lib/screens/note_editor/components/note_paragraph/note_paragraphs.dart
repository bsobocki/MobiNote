import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph_placeholder.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';

import 'note_paragraph_texteditor.dart';
import 'note_paragraph_widget.dart';

class NoteParagraphs {
  IdGenerator paragraphIdGenerator = IdGenerator();
  int focusedParagraphId = 0;
  List<NoteParagraph> paragraphs = [];

  final String initContent;
  final void Function(void Function()) setContentEditorState;
  final void Function(String) onChange;

  NoteParagraphs({
    required this.onChange,
    required this.initContent,
    required this.setContentEditorState,
  }) {
    createParagraphs(initContent);
  }

  int get length => paragraphs.length;
  NoteParagraph at(int index) => paragraphs[index];

  String text() {
    String returnText = '';
    if (paragraphs.isNotEmpty) {
      if (paragraphs.length == 1) {
        return paragraphs.last.text;
      }
      for (int i = 0; i < paragraphs.length - 1; i++) {
        returnText += "${paragraphs[i].text}\n";
      }
    }
    return returnText;
  }

  int paragraphIndexOf(int paragraphId) =>
      paragraphs.indexWhere((element) => element.id == paragraphId);

  int indexOfFocusedParagraph() {
    int index =
        paragraphs.indexWhere((element) => element.id == focusedParagraphId);
    return index == -1 ? paragraphs.length : index;
  }

  void reportFocusParagraph(int paragraphId) {
    focusedParagraphId = paragraphId;
    debugPrint(
        "== REPORT FOCUS === Now, the paragraph $focusedParagraphId is focuded one.");
  }

  void createParagraphs(String text) {
    if (text.isEmpty) {
      addNewNoteParagraphEditor('');
    } else {
      String currText = '';
      for (int i = 0; i < text.length; i++) {
        if (text[i] == '\n') {
          addNewNoteParagraphEditor(currText);
          currText = '';
        } else {
          currText += text[i];
        }
      }

      if (currText.isNotEmpty) {
        addNewNoteParagraphEditor(currText);
      }
    }
    paragraphs.add(
      NoteParagraphPlaceholder(
        id: paragraphIdGenerator.nextId,
        onTap: () {
          var lastValidParagraph = paragraphs[paragraphs.length - 2];
          lastValidParagraph.requestFocus();
        },
      ),
    );
  }

  void addNewNoteParagraphEditor(String text) {
    var newParagraph = createNoteParagraphTextEditor(text);
    paragraphs.add(newParagraph);
  }

  void addParagraphWithWidget(NoteWidgetData data) {
    int focusedParagraphIndex = indexOfFocusedParagraph();
    var noteParagraphWidget = createNoteParagraphWidget();
    noteParagraphWidget.addWidgetByData(data);
    int newItemIndex = focusedParagraphIndex + 1;

    if (paragraphs[focusedParagraphIndex] is NoteParagraphTextEditor) {
      if (paragraphs[focusedParagraphIndex].text.isEmpty) {
        paragraphs.removeAt(focusedParagraphIndex);
        newItemIndex = focusedParagraphIndex;
      }
    }

    paragraphs.insert(
      newItemIndex,
      noteParagraphWidget,
    );

    paragraphs.insert(newItemIndex + 1, createNoteParagraphTextEditor(''));
  }

  void addEmptyNoteParagraphWidget() {
    paragraphs.add(createNoteParagraphWidget());
  }

  void addNoteParagraphEditorAfter(int prevParagraphId, String text) =>
      setContentEditorState(() {
        var newParagraph = createNoteParagraphTextEditor(text);

        if (paragraphs.isEmpty || prevParagraphId == -1) {
          paragraphs.add(newParagraph);
        } else {
          int index = paragraphs.length - 1;
          int prevParagraphIndex = paragraphIndexOf(prevParagraphId);

          if (exists(prevParagraphIndex)) {
            index = prevParagraphIndex + 1;
          }

          paragraphs.insert(index, newParagraph);
        }
      });

  void deleteNoteParagraph(int paragraphId) => setContentEditorState(() {
        int index = paragraphIndexOf(paragraphId);
        int prevIndex = index - 1;
        var currParagraph = paragraphs[index];
        String newText = currParagraph.text;
        if (exists(index) && prevIndex >= 0) {
          if (currParagraph is NoteParagraphWidget) {
            paragraphs.removeAt(index);
          } else {
            var prevParagraph = paragraphs[prevIndex];
            if (prevParagraph is NoteParagraphTextEditor) {
              var foundedParagraphEditor =
                  paragraphs[prevIndex] as NoteParagraphTextEditor;
              newText = foundedParagraphEditor.text + paragraphs[index].text;
              int cursor = foundedParagraphEditor.rawLength;
              paragraphs[prevIndex] = createNoteParagraphTextEditor(newText)
                ..cursor = cursor;
              paragraphs.removeAt(index);
            } else if (prevParagraph is NoteParagraphWidget) {
              prevParagraph.setMode!(WidgetMode.edit);
              prevParagraph.requestFocus();
              if (currParagraph is NoteParagraphTextEditor) {
                currParagraph.addPlaceholder();
              }
            }
          }
        }
      });

  NoteParagraphWidget createNoteParagraphWidget() {
    debugPrint("create note widget paragraph!!!");
    return NoteParagraphWidget(
      id: paragraphIdGenerator.nextId,
      reportFocusParagraph: reportFocusParagraph,
      deleteParagraph: deleteNoteParagraph,
      widgetJSON: '',
    );
  }

  NoteParagraphTextEditor createNoteParagraphTextEditor(text) {
    return NoteParagraphTextEditor(
      id: paragraphIdGenerator.nextId,
      paragraphText: text,
      onChange: onChange,
      addParagraph: addNoteParagraphEditorAfter,
      deleteParagraph: deleteNoteParagraph,
      reportFocusParagraph: reportFocusParagraph,
    );
  }
}
