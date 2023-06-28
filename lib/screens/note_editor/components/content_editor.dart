import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/paragraph_editor.dart';

import '../../../logic/helpers/list_helpers.dart';
import '../../../logic/text_editor/id/paragraph_id_generator.dart';

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
      addNewParagraph('');
    } else {
      String currText = '';
      for (int i = 0; i < text.length; i++) {
        if (text[i] == '\n') {
          addNewParagraph(currText);
          currText = '';
        } else {
          currText += text[i];
        }
      }

      if (currText.isNotEmpty) {
        addNewParagraph(currText);
      }
    }
  }

  void addNewParagraph(String text) {
    var newParagraph = NoteParagraph(
      id: paragraphIdGenerator.nextId,
      paragraphText: text,
      onChange: onChange,
      addParagraph: addParagraph,
      deleteParagraph: deleteParagraph,
    );
    paragraphs.add(newParagraph);
  }

  void addParagraph(int prevParagraphId, String text) => setState(() {
        var newParagraph = NoteParagraph(
          id: paragraphIdGenerator.nextId,
          paragraphText: text,
          onChange: onChange,
          addParagraph: addParagraph,
          deleteParagraph: deleteParagraph,
        );

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

        newParagraph.focusNode.requestFocus();
      });

  void deleteParagraph(int paragraphId) => setState(() {
        int index = paragraphIndexOf(paragraphId);
        if (found(index) && index > 0) {
          paragraphs[index - 1].appendText(paragraphs[index].text);
          paragraphs.removeAt(index);
          paragraphs[index - 1].focusNode.requestFocus();
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
