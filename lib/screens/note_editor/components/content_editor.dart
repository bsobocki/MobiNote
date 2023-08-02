import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_image_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraphs.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/helpers/images.dart';

int change = 1;
String lastNewText = "";

// ignore: must_be_immutable
class ContentEditor extends StatefulWidget {
  final Function(String value) onContentChange;
  final String initContent;
  final String initWidgets;
  String Function()? contentFromState;

  ContentEditor(
      {super.key,
      required this.initContent,
      required this.onContentChange,
      required this.initWidgets});

  String get content {
    if (contentFromState != null) {
      return contentFromState!();
    }
    return '';
  }

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  NoteEditorWidgetFactory widgetFactory = NoteEditorWidgetFactory();
  bool contentChanged = false;
  late NoteParagraphs paragraphs;
  int focusedParagraphId = -1;

  void setContentEditorState(void Function() fn) {
    setState(() {
      fn();
    });
  }

  void addParagraphWithImage() async {
    String path = await chooseImage();
    NoteImageData data = NoteImageData(id: -1, path: path);
    paragraphs.addParagraphWithWidget(data);
    setState(() {
      for (var p in paragraphs.paragraphs) {
        debugPrint(p.str);
      }
    });
  }

  void addParagraphWithList() => setState(() {
        NoteListData data =
            NoteListData(id: -1, elemType: ElementType.checkbox);
        paragraphs.addParagraphWithWidget(data);
      });

  void onChange(String newText) => widget.onContentChange(newText);

  @override
  void initState() {
    super.initState();
    paragraphs = NoteParagraphs(
      widgetFactory: widgetFactory,
      onChange: onChange,
      initContent: widget.initContent,
      setContentEditorState: setContentEditorState,
    );
    widget.contentFromState = paragraphs.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        toolbarHeight: 30,
        actions: [
          IconButton(
              onPressed: addParagraphWithImage, icon: const Icon(Icons.image)),
          IconButton(
              onPressed: addParagraphWithList, icon: const Icon(Icons.list))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: paragraphs.length,
          itemBuilder: (context, index) {
            return paragraphs.at(index);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(
        255,
        75,
        75,
        75,
      ),
    );
  }
}
