import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/paragraph_editor.dart';

int change = 1;
String lastNewText = "";

class ContentEditor extends StatefulWidget {
  final Function(String value) onContentChange;
  final String initContent;
  final String initWidgets;
  List<NoteParagraph> paragraphs = [];

  ContentEditor(
      {super.key,
      required this.initContent,
      required this.onContentChange,
      required this.initWidgets});

  int paragraphIndexOf(int paragraphId) =>
      paragraphs.indexWhere((element) => element.id == paragraphId);

  String get text {
    String returnText = '';
    if (paragraphs.isNotEmpty) {
      int i = 0;
      for (; i < paragraphs.length; i++) {
        returnText += "${paragraphs[i].text}\n";
      }
      returnText += paragraphs.last.text;
    }

    return returnText;
  }

  String get widgets => '';

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  bool contentChanged = false;
  late Function(String value) onContentChange;

  @override
  void dispose() {
    super.dispose();
  }

  void onChange(String newText) {
    setState(() {
      onContentChange(newText);
    });
  }

  void createParagraphs(String text) {
    debugPrint('TEXT---');
    debugPrint(text);
    debugPrint('---TEXT');
    debugPrint("creating paragraphs:");
    if (text.isEmpty) {
      addParagraph(-1, '');
    } else {
      int index = 0;
      String currText = '';
      for (int i = 0; i < text.length; i++) {
        if (text[i] == '\n') {
          debugPrint('add paragraph: $currText');
          addParagraph(-1, currText);
          currText = '';
        } else {
          currText += text[i];
        }
      }

      if (currText.isNotEmpty) {
        addParagraph(index, currText);
      }
    }
  }

  void addParagraph(int prevParagraphId, String text) {
    debugPrint('-----------------------------------');

    var newParagraph = NoteParagraph(
      paragraphText: text,
      onChange: onChange,
      addParagraph: addParagraph,
    );

    if (widget.paragraphs.isEmpty || prevParagraphId == -1) {
      widget.paragraphs.add(newParagraph);
    } else {
      int index = widget.paragraphs.length - 1;
      int prevParagraphIndex = widget.paragraphIndexOf(prevParagraphId);

      if (prevParagraphIndex != -1) {
        index = prevParagraphIndex + 1;
      }

      debugPrint("Paragraphs before change:");
      for (var element in widget.paragraphs) debugPrint(element.str);

      widget.paragraphs.insert(index, newParagraph);

      debugPrint("Paragraphs after change:");
      for (var element in widget.paragraphs) debugPrint(element.str);
    }
  }

  @override
  void initState() {
    createParagraphs(widget.initContent);
    for (var element in widget.paragraphs) {
      debugPrint(element.str);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onContentChange = widget.onContentChange;
    return Scrollbar(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.paragraphs.length,
          itemBuilder: (BuildContext context, int index) {
            return widget.paragraphs[index];
          }),
    );
  }
}
