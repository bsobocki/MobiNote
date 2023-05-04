// import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/widgets/note_button_widget.dart';
import 'create_note.dart';
import 'database/database_def.dart';

const double listViewPadding = 30.0;
const double listDivideSpaceSize = 15;
const Color themeColor = Color.fromARGB(255, 51, 51, 51);
const Color pageBackgroundColor = Color.fromARGB(255, 75, 75, 75);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MobiNoteDatabase());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobiNote',
      theme: ThemeData(
        primaryColor: themeColor,
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: themeColor),
        dialogBackgroundColor: themeColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: themeColor, 
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.white),
      ),
      home: const MyHomePage(title: 'MobiNote'),
    );
  }
}

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

  // void showDatabasePage() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => DriftDbViewer(database),
  //   ));
  // }

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
          );
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

    return ListView(
      padding: const EdgeInsets.all(listViewPadding),
      children: noteListWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: themeColor,
        actions: const [
          // IconButton(
          //   onPressed: showDatabasePage,
          //   tooltip: 'Show Database',
          //   icon: const Icon(Icons.storage),
          // ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: pageBackgroundColor),
        child: FutureBuilder<List<Note>>(
          future: _notesFuture,
          builder: noteListViewBuilder,
        ),
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
    );
  }

  void profileButtonAction() {}
}
