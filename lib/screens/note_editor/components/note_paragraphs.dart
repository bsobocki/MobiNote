import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/id/paragraph_id_generator.dart';
import 'package:mobi_note/logic/helpers/list_helpers.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_image_widget.dart';

import 'note_text/note_paragraph_texteditor.dart';
import 'note_widgets/note_paragraph_widget.dart';
import 'note_widgets/note_widget.dart';

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
      returnText += paragraphs.last.text;
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
    debugPrint("Now, the paragraph $focusedParagraphId is focuded one.");
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
  }

  void addNewNoteParagraphEditor(String text) {
    var newParagraph = createNoteParagraphTextEditor(text);
    paragraphs.add(newParagraph);
  }

  void addNoteImageWidget(String path) {
    int focusedParagraphIndex = indexOfFocusedParagraph();
    paragraphs.insert(
      focusedParagraphIndex,
      createNoteParagraphWidget('', [NoteImageWidget(path: path)])
    );
  }

  void addNewNoteParagraphWidget(String widgetsJSON) {
    var newParagraph = createNoteParagraphWidget(widgetsJSON,[]);
    paragraphs.add(newParagraph);
  }

  void addNoteParagraphEditorAfter(int prevParagraphId, String text) =>
      setContentEditorState(() {
        var newParagraph = createNoteParagraphTextEditor(text);

        if (paragraphs.isEmpty || prevParagraphId == -1) {
          paragraphs.add(newParagraph);
        } else {
          int index = paragraphs.length - 1;
          int prevParagraphIndex = paragraphIndexOf(prevParagraphId);

          if (found(prevParagraphIndex)) {
            index = prevParagraphIndex + 1;
          }

          paragraphs.insert(index, newParagraph);
        }
      });

  void deleteNoteParagraphEditor(int paragraphId) => setContentEditorState(() {
        int index = paragraphIndexOf(paragraphId);
        int prevIndex = index - 1;
        if (found(index) && prevIndex >= 0) {
          var prevParagrpah = paragraphs[prevIndex];
          if (prevParagrpah is NoteParagraphTextEditor) {
            var foundParagraphEditor =
                paragraphs[prevIndex] as NoteParagraphTextEditor;
            int cursor = foundParagraphEditor.rawLength;
            String newText = foundParagraphEditor.text + paragraphs[index].text;
            paragraphs[prevIndex] = createNoteParagraphTextEditor(newText);
            (paragraphs[prevIndex] as NoteParagraphTextEditor).cursor = cursor;
            paragraphs.removeAt(index);
          } else if (prevParagrpah is NoteParagraphWidget) {
            //prevParagrpah.set
          }
        }
      });

  NoteParagraphWidget createNoteParagraphWidget(String widgetsJSON, List<NoteEditorWidget> elements) {
    return NoteParagraphWidget(
      id: paragraphIdGenerator.nextId,
      reportFocusParagraph: reportFocusParagraph,
      widgetJSON: widgetsJSON,
      elements: elements,
    );
  }

  NoteParagraphTextEditor createNoteParagraphTextEditor(text) {
    return NoteParagraphTextEditor(
      id: paragraphIdGenerator.nextId,
      paragraphText: text,
      onChange: onChange,
      addParagraph: addNoteParagraphEditorAfter,
      deleteParagraph: deleteNoteParagraphEditor,
      reportFocusParagraph: reportFocusParagraph,
    );
  }
}
