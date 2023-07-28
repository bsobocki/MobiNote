import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/screens/test_pages/add_raw_text_note_test_page.dart';
import '../../database/database_def.dart';
import '../../database/database_operations.dart';
import '../note_editor/note_editor.dart';
import 'note_button_widget.dart';

const Note invalidNote = Note(id: -1, title: '', content: '', widgets: '');

const double listViewPadding = 30.0;
const double listDivideSpaceSize = 15;
const Color themeColor = Color.fromARGB(255, 51, 51, 51);
const Color pageBackgroundColor = Color.fromARGB(255, 75, 75, 75);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final database = Get.find<MobiNoteDatabase>();
  late Future<List<Note>> _notesFuture;
  final double appBarHeight = AppBar().preferredSize.height;
  double bottomPadding(context) => MediaQuery.of(context).padding.bottom;
  double listViewHeight(context) =>
      MediaQuery.of(context).size.height -
      appBarHeight -
      bottomPadding(context) -
      listViewPadding;

  void showTestPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => RawNoteEditorTestPage(
              id: invalidNote.id,
              title: invalidNote.title,
              content: invalidNote.content),
        ))
        .then((value) => updateNotesListView());
  }

  void createNewNotePage() {
    openNoteEditorPage(invalidNote);
  }

  void openNoteEditorPage([Note note = invalidNote]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return NoteEditorPage(
              id: note.id,
              title: note.title,
              content: note.content,
              widgets: note.widgets);
        },
      ),
    ).then((value) => updateNotesListView());
  }

  void updateNotesListView() {
    setState(() {
      _notesFuture = database.allNotes;
    });
  }

  @override
  void initState() {
    super.initState();
    updateNotesListView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget noteListViewBuilder(
      BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (!snapshot.hasData) {
      return const Center(child: Text("No notes found"));
    }
    List<Widget> noteListWidgets = [];
    for (var note in snapshot.data!.toList()) {
      noteListWidgets.add(
        NoteWidget(
          note: note,
          noteAction: openNoteEditorPage,
          updateViewAction: updateNotesListView,
        ),
      );
      noteListWidgets.add(const SizedBox(height: listDivideSpaceSize));
    }

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(
          top: 14,
          left: listViewPadding,
          right: listViewPadding,
          bottom: listViewPadding,
        ),
        children: noteListWidgets,
      ),
    );
  }

  Widget get notebooksWidget {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30),
      child: SizedBox(
        height: 170,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    minimumSize: Size(double.infinity, 150),
                  ),
                  onPressed: () {},
                  child: const Text('Trainings'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    minimumSize: Size(double.infinity, 150),
                  ),
                  onPressed: () {},
                  child: const Text('Diet'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: themeColor,
        actions: [
          IconButton(
            onPressed: showTestPage,
            tooltip: 'Show Database',
            icon: const Icon(Icons.storage),
          ),
          IconButton(
              onPressed: () => rebuildDatabase(),
              icon: const Icon(Icons.build_circle_sharp))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewNotePage,
        tooltip: 'Create a new Note',
        child: const Icon(Icons.create),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: pageBackgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0),
              child: Text(
                "Notebooks:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            notebooksWidget,
            const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 30.0),
              child: Text(
                "Recent Notes:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            FutureBuilder<List<Note>>(
              future: _notesFuture,
              builder: noteListViewBuilder,
            ),
          ],
        ),
      ),
    );
  }

  void profileButtonAction() {}
}
