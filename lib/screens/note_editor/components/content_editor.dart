import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraphs.dart';
import 'package:image_picker/image_picker.dart';

int change = 1;
String lastNewText = "";

// ignore: must_be_immutable
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
  ImagePicker picker = ImagePicker();
  bool contentChanged = false;
  late NoteParagraphs paragraphs;
  int focusedParagraphId = -1;

  String text() => paragraphs.text();

  void setContentEditorState(void Function() fn) {
    setState(() {
      fn();
    });
  }

  void chooseAndAddImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        debugPrint("add image from: ${image.path}");
        paragraphs.addNoteImageWidget(image.path);
        for (var p in paragraphs.paragraphs) {
          debugPrint(p.str);
        }
      });
    }
  }

  void onChange(String newText) => widget.onContentChange(newText);

  @override
  void initState() {
    super.initState();
    widget.text = text;
    paragraphs = NoteParagraphs(
        onChange: onChange,
        initContent: widget.initContent,
        setContentEditorState: setContentEditorState);
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
              onPressed: chooseAndAddImage, icon: const Icon(Icons.image))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: paragraphs.length,
            itemBuilder: (context, index) {
              return paragraphs.at(index);
            },
          )),
      backgroundColor: const Color.fromARGB(
        255,
        75,
        75,
        75,
      ),
    );
  }
}
