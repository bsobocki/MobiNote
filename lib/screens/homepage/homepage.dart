import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/screens/test_pages/add_raw_text_note_test_page.dart';
import 'package:mobi_note/screens/theme/themes.dart';
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
  int bottomNavigationBarCurrentIndex = 1;
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
    for (var note in snapshot.data!.toList().reversed) {
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
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 14,
          left: listViewPadding,
          right: listViewPadding,
          bottom: listViewPadding,
        ),
        itemCount: noteListWidgets.length,
        itemBuilder: (context, index) => noteListWidgets[index]
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
                    backgroundColor:
                        MobiNoteTheme.current.buttonBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    minimumSize: const Size(double.infinity, 150),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Trainings',
                    style: TextStyle(
                        color: MobiNoteTheme.current.textColor,
                        fontSize: paragraphDefaultFontSize +
                            MobiNoteTheme.current.fontSizeAddVal),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        MobiNoteTheme.current.buttonBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    minimumSize: const Size(double.infinity, 150),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Diet',
                    style: TextStyle(
                        color: MobiNoteTheme.current.textColor,
                        fontSize: paragraphDefaultFontSize +
                            MobiNoteTheme.current.fontSizeAddVal),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> rebuildDatabaseDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rebuilding Database Confirmation'),
          backgroundColor: MobiNoteTheme.current.siteBackgroundColor,
          content: const Text(
            'Do you want to delete database and rebuild it?\n',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Rebuild'),
              onPressed: () {
                rebuildDatabase();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> chooseThemeDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          backgroundColor: MobiNoteTheme.current.siteBackgroundColor,
          titleTextStyle: TextStyle(color: MobiNoteTheme.current.textColor, fontSize: header3DefaultFontSize),
          contentTextStyle: TextStyle(color: MobiNoteTheme.current.textColor, fontSize: paragraphDefaultFontSize),
          content: const Text(
            'Choose theme that you want to use\n',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Dark'),
              onPressed: () {
                MobiNoteTheme.setTheme(NoteScreenThemes.dark);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Light'),
              onPressed: () {
                MobiNoteTheme.setTheme(NoteScreenThemes.light);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Easy'),
              onPressed: () {
                MobiNoteTheme.setTheme(NoteScreenThemes.easy);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: MobiNoteTheme.current.textColor),
        ),
        backgroundColor: MobiNoteTheme.current.barColor,
        actions: [
          PopupMenuButton(
            color: MobiNoteTheme.current.buttonBackgroundColor,
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    'Choose Theme',
                    style: TextStyle(
                      color: MobiNoteTheme.current.textColor,
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(
                    'Rebuild Database',
                    style: TextStyle(color: MobiNoteTheme.current.textColor),
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case 0:
                  await chooseThemeDialogBuilder(context);
                  break;
                case 1:
                  await rebuildDatabaseDialogBuilder(context);
                  break;
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewNotePage,
        backgroundColor: MobiNoteTheme.current.barColor,
        tooltip: 'Create a new Note',
        child: Icon(Icons.create, color: MobiNoteTheme.current.textColor),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavigationBarCurrentIndex,
        onTap: (index) {
          setState(() {
            bottomNavigationBarCurrentIndex = index;
          });
        },
        selectedItemColor: MobiNoteTheme.current.textColor,
        unselectedItemColor: MobiNoteTheme.current.textColor.withOpacity(0.6),
        backgroundColor: MobiNoteTheme.current.barColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: Container(
        decoration:
            BoxDecoration(color: MobiNoteTheme.current.siteBackgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 30.0),
              child: Text(
                "Notebooks:",
                style: TextStyle(
                    fontSize: 16 + MobiNoteTheme.current.fontSizeAddVal,
                    fontWeight: FontWeight.bold,
                    color: MobiNoteTheme.current.textColor),
              ),
            ),
            notebooksWidget,
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 30.0),
              child: Text(
                "Recent Notes:",
                style: TextStyle(
                    fontSize: 16 + MobiNoteTheme.current.fontSizeAddVal,
                    fontWeight: FontWeight.bold,
                    color: MobiNoteTheme.current.textColor),
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
