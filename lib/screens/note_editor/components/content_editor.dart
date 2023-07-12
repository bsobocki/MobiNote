import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_text/paragraph_editor.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/paragraph_widget.dart';

import '../../../logic/helpers/list_helpers.dart';
import '../../../logic/helpers/id/paragraph_id_generator.dart';

int change = 1;
String lastNewText = "";

class ContentEditor extends StatefulWidget {
  final Function(String value) onContentChange;
  final String initContent;
  final String initWidgets;
  late String Function() text;

  ContentEditor(
      {super.key,
      required this.initContent,
      required this.onContentChange,
      required this.initWidgets});

  String get widgets => '';

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  bool contentChanged = false;
  List<NoteParagraph> paragraphs = [];
  int focusedParagraphId = -1;

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

  @override
  void dispose() {
    super.dispose();
  }

  void onChange(String newText) {
    widget.onContentChange(newText);
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

  void reportFocusParagraph(int paragraphId) {
    focusedParagraphId = paragraphId;
    debugPrint("Now, the paragraph $focusedParagraphId is focuded one.");
  }

  int indexOfFocusedParagraph() {
    return 0;
  }

  void addNewNoteParagraphWidget(String type) {
    var newParagraph = createNoteParagraphWidget(type);
    paragraphs.add(newParagraph);
  }

  NoteParagraphWidget createNoteParagraphWidget(String type) {
    return NoteParagraphWidget(
      id: paragraphIdGenerator.nextId,
      reportFocusParagraph: reportFocusParagraph,
      widgetJSON: '',
    );
  }

  void addNewNoteParagraphEditor(String text) {
    var newParagraph = createNoteParagraphEditor(text);
    paragraphs.add(newParagraph);
  }

  NoteParagraphEditor createNoteParagraphEditor(text) {
    return NoteParagraphEditor(
      id: paragraphIdGenerator.nextId,
      paragraphText: text,
      onChange: onChange,
      addParagraph: addNoteParagraphEditorAfter,
      deleteParagraph: deleteNoteParagraphEditor,
      reportFocusParagraph: reportFocusParagraph,
    );
  }

  void addNoteParagraphEditorAfter(int prevParagraphId, String text) =>
      setState(() {
        var newParagraph = createNoteParagraphEditor(text);

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

  void deleteNoteParagraphEditor(int paragraphId) => setState(() {
        int index = paragraphIndexOf(paragraphId);
        if (found(index) && index > 0) {
          var foundParagraphEditor =
              paragraphs[index - 1] as NoteParagraphEditor;
          int cursor = foundParagraphEditor.rawLength;
          String newText = foundParagraphEditor.text + paragraphs[index].text;
          paragraphs[index - 1] = createNoteParagraphEditor(newText);
          (paragraphs[index - 1] as NoteParagraphEditor).cursor = cursor;
          paragraphs.removeAt(index);
        }
      });

  @override
  void initState() {
    widget.text = text;
    createParagraphs(widget.initContent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paragraphs.length,
      itemBuilder: (context, index) {
        return paragraphs[index];
      },
    );
  }
}
