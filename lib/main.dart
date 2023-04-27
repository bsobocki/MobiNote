import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/database/note_widget.dart';
import 'create_note.dart';
import 'database/database_def.dart';

const double listViewPadding = 30.0;

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
        primarySwatch: Colors.blue,
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

  void showDatabase() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DriftDbViewer(database),
    ));
  }

  void createNewNotePage() {
    openNoteEditorPage(-1, '', '');
  }

  void openNoteEditorPage(int id, String title, String content) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return NoteEditorPage(id: id, title: title, content: content);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: showDatabase,
            tooltip: 'Show Database',
            icon: const Icon(Icons.storage),
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
          future: _notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              List<Note> allNotes = snapshot.data?.toList() ?? [];
              List<Widget> noteListWidgets = [];
              for (var note in allNotes) {
                noteListWidgets.add(
                  SizedBox(
                    width: 20,
                    child: NoteWidget(
                      note: note,
                      noteAction: openNoteEditorPage,
                      updateViewAction: updateNotesListView,
                    ),
                  ),
                );
                noteListWidgets.add(const SizedBox(height: 30));
              }

              return Center(
                child: SizedBox(
                  height: listViewHeight(context),
                  child: ListView(
                    padding: const EdgeInsets.all(listViewPadding),
                    children: noteListWidgets,
                  ),
                ),
              );
            } else {
              return const Center(child: Text("No notes found"));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewNotePage,
        tooltip: 'Create a new Note',
        child: const Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
