import 'package:flutter/material.dart';
import 'package:mobi_note/main.dart';
import 'package:mobi_note/note_editor/note_element.dart';

const double noteContentPadding = 10.0;
const TextStyle defaultTextStyle =
    TextStyle(fontSize: noteContentDefaultFontSize);

class NoteContentEditor extends StatefulWidget {
  const NoteContentEditor({
    super.key,
    required this.onChanged,
    required this.contentController,
  });

  final TextEditingController contentController;
  final Function(String) onChanged;

  @override
  State<NoteContentEditor> createState() => _NoteContentEditorState();
}

class _NoteContentEditorState extends State<NoteContentEditor> {
  final focusNode = FocusNode();
  // ignore: prefer_const_constructors
  TextStyle currentStyle = defaultTextStyle;
  List<RowElem> rows = [];
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    addEmptyRow();
  }

  void addEmptyRow() => rows.add(
        RowElem(
          elements: [
            TextElem(text: '', style: defaultTextStyle, onChanged: onChanged),
          ],
        ),
      );

  void onChanged(value) {
    setState(() => widget.onChanged(value));
  }

  void addElement(NoteElement element) {
    var currRow = rows.last;

    debugPrint(
        "add: ${currRow.width + element.width} and screenWidth: $screenWidth");
    if (currRow.width + element.width > screenWidth) {
      debugPrint("dodajemyy!");
      addEmptyRow();
      currRow = rows.last;
    }

    var lastElem = currRow.last;

    if (lastElem is! TextElem) {
      throw ErrorDescription(
          "Add Element: The last of elements is not a Text!");
    }

    setState(() {
      if (lastElem.editingController.text.isEmpty) {
        if (currRow.length > 1) {
          currRow.insert(currRow.length - 2, element);
        } else {
          currRow.elementsList = [element, lastElem];
        }
      } else {
        currRow.add(element);
        currRow
            .add(TextElem(text: '', style: currentStyle, onChanged: onChanged));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        actions: [
          IconButton(
            onPressed: () => addElement(
              CheckBoxElem(val: false, onChanged: (val) {}),
            ),
            icon: const Icon(Icons.check_box_outlined),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          screenWidth = constraints.maxWidth;

          return Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 75, 75, 75)),
            child: Column(
              children: rows.map((e) => e.widget).toList(),
            ),
          );
        },
      ),
    );
  }
}

// mogę zrobić render na poczekaniu, tylko TextField niewidoczny pod tym.. 
// przy zmianie tego, wymuszę render