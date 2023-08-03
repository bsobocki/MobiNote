import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_image_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_data.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_list_element_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph/note_paragraphs.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/factory/note_widget_factory.dart';
import 'package:mobi_note/screens/note_editor/helpers/images.dart';
import 'package:mobi_note/screens/theme/themes.dart';

int change = 1;
String lastNewText = "";

// ignore: must_be_immutable
class ContentEditor extends StatefulWidget {
  final Function() onContentChange;
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

  void onChange() => widget.onContentChange();

  @override
  void initState() {
    super.initState();
    paragraphs = NoteParagraphs(
      widgetFactory: widgetFactory,
      onContentChange: onChange,
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
        backgroundColor: MobiNoteTheme.current.buttonBackgroundColor,
        toolbarHeight: 40 + MobiNoteTheme.current.fontSizeAddVal,
        actions: [
          IconButton(
              onPressed: addParagraphWithImage, icon: Icon(Icons.image, color: MobiNoteTheme.current.textColor, size: paragraphDefaultFontSize * 2,),),
          IconButton(
              onPressed: addParagraphWithList, icon: Icon(Icons.list, color: MobiNoteTheme.current.textColor, size: paragraphDefaultFontSize * 2),)
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
      backgroundColor: MobiNoteTheme.current.siteBackgroundColor,
    );
  }
}
