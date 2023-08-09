import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/logic/helpers/text_is_widget.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/all_widget_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraph_placeholder.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';

import 'note_paragraph_texteditor.dart';
import 'note_paragraph_widget.dart';

class NoteParagraphs {
  IdGenerator paragraphIdGenerator = IdGenerator();
  NoteEditorWidgetFactory noteWidgetFactory;
  int focusedParagraphId = 0;
  List<NoteParagraph> paragraphs = [];

  final String initContent;
  final void Function(void Function()) setContentEditorState;
  final void Function() onContentChange;

  NoteParagraphs({
    required this.noteWidgetFactory,
    required this.onContentChange,
    required this.initContent,
    required this.setContentEditorState,
  }) {
    createParagraphs(initContent);
  }

  int get length => paragraphs.length;
  NoteParagraph at(int index) => paragraphs[index];

  String content() {
    String returnText = '';
    if (paragraphs.isNotEmpty) {
      if (paragraphs.length == 1) {
        return paragraphs.last.content;
      }
      for (int i = 0; i < paragraphs.length - 1; i++) {
        returnText += "${paragraphs[i].content}\n";
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
  }

  void createParagraphs(String text) {
    if (text.isEmpty) {
      addNewNoteParagraphEditor('');
    } else {
      String currText = '';
      for (int i = 0; i < text.length; i++) {
        if (text[i] == '\n') {
          if (!isWidget(currText)) {
            addNewNoteParagraphEditor(currText);
          } else {
            addNewNoteParagraphWidget(currText);
          }
          focusedParagraphId = paragraphIdGenerator.currId - 1;
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
        noteWidgetFactory: noteWidgetFactory,
        onTap: () {
          var lastValidParagraph = paragraphs[paragraphs.length - 2];
          lastValidParagraph.requestFocus();
          reportFocusParagraph(lastValidParagraph.id);
        },
      ),
    );
  }

  void addNewNoteParagraphEditor(String text) {
    var newParagraph = createNoteParagraphTextEditor(text);
    paragraphs.add(newParagraph);
    onContentChange();
  }

  void addNewNoteParagraphWidget(String text) {
    String jsonStr = text.substring(3);
    try {
      List<dynamic> jsonObjects = jsonDecode(jsonStr);
      List<NoteWidgetData> widgetsData =
          jsonObjects.map((e) => createData(e)).toList();
      addParagraphWithWidgets(
        widgetsData,
        addTextEditorAfter: false,
        overriteParagraphIfNeeded: false,
      );
    } catch (e) {
      debugPrint('cannot add widget from JSON: $e');
    }
  }

  void addParagraphWithWidget(NoteWidgetData data) {
    addParagraphWithWidgets([data]);
  }

  void addParagraphWithWidgets(List<NoteWidgetData> widgetsData,
      {bool addTextEditorAfter = true, bool overriteParagraphIfNeeded = true}) {
    int focusedParagraphIndex = indexOfFocusedParagraph();
    var noteParagraphWidget = createNoteParagraphWidget();

    for (var data in widgetsData) {
      noteParagraphWidget.addWidgetByData(data);
    }

    int newItemIndex = focusedParagraphIndex + 1;

    if (paragraphs.isEmpty) {
      newItemIndex = 0;
    } else if (overriteParagraphIfNeeded) {
      if (paragraphs[focusedParagraphIndex] is NoteParagraphTextEditor &&
          paragraphs[focusedParagraphIndex].content.isEmpty) {
        paragraphs.removeAt(focusedParagraphIndex);
        newItemIndex = focusedParagraphIndex;
      }
    }

    if (newItemIndex >= paragraphs.length) {
      paragraphs.add(noteParagraphWidget);
      newItemIndex = paragraphs.length - 1;
    } else {
      paragraphs.insert(
        newItemIndex,
        noteParagraphWidget,
      );
    }

    if (addTextEditorAfter) {
      paragraphs.insert(newItemIndex + 1, createNoteParagraphTextEditor(''));
    }
    onContentChange();
  }

  void addEmptyNoteParagraphWidget() {
    paragraphs.add(createNoteParagraphWidget());
    onContentChange();
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
        onContentChange();
      });

  void deleteNoteParagraph(int paragraphId) => setContentEditorState(() {
        int index = paragraphIndexOf(paragraphId);
        int prevIndex = index - 1;
        var currParagraph = paragraphs[index];
        String newText = currParagraph.content;
        if (exists(index) && prevIndex >= 0) {
          if (currParagraph is NoteParagraphWidget) {
            paragraphs.removeAt(index);
            if (paragraphs.length < index) {
              paragraphs[index].requestFocus();
            }
          } else {
            var prevParagraph = paragraphs[prevIndex];
            if (prevParagraph is NoteParagraphTextEditor) {
              var foundedParagraphEditor =
                  paragraphs[prevIndex] as NoteParagraphTextEditor;
              newText =
                  foundedParagraphEditor.content + paragraphs[index].content;
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
          reportFocusParagraph(paragraphs[prevIndex].id);
        }
        if (index == 0 && currParagraph is NoteParagraphWidget) {
          paragraphs.removeAt(0);
          if (paragraphs.isEmpty) {
            addNewNoteParagraphEditor('');
          }
        }
        onContentChange();
      });

  NoteParagraphWidget createNoteParagraphWidget() {
    return NoteParagraphWidget(
      id: paragraphIdGenerator.nextId,
      noteWidgetFactory: noteWidgetFactory,
      onContentChange: onContentChange,
      reportFocusParagraph: reportFocusParagraph,
      deleteParagraph: deleteNoteParagraph,
      widgetJSON: '',
    );
  }

  NoteParagraphTextEditor createNoteParagraphTextEditor(text) {
    return NoteParagraphTextEditor(
      id: paragraphIdGenerator.nextId,
      noteWidgetFactory: noteWidgetFactory,
      paragraphText: text,
      onContentChange: onContentChange,
      addParagraph: addNoteParagraphEditorAfter,
      deleteParagraph: deleteNoteParagraph,
      reportFocusParagraph: reportFocusParagraph,
    );
  }
}
