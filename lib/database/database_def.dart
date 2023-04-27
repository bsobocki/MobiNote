import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_dart;

part 'database_def.g.dart';

class DBInfo {
  static Directory? _dir;
  static const String name = 'mobinote_db.sqlite';

  static void initialize(Directory directory) {
    _dir ??= directory;
  }

  static Directory get dir {
    if (_dir == null) {
      throw Exception('DataBase has not been initialized.');
    }
    return _dir!;
  }

  static bool get isInitialized => _dir != null;
}

@DataClassName('Note')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  @JsonKey('body') //This is required for the drift_db_viewer.
  TextColumn get content => text().named('body')();
}

@DataClassName('Tag')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('TagNote')
class TagNotes extends Table {
  IntColumn get tagId => integer()();
  IntColumn get noteId => integer()();
}

@DriftDatabase(tables: [Notes, Tags, TagNotes])
class MobiNoteDatabase extends _$MobiNoteDatabase {
  MobiNoteDatabase() : super(_openConnection());

  Future<List<Note>> get allNotes => select(notes).get();

  Future<Note?> getNoteWithId(int id) =>
      (select(notes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<void> updateNote(Note updatedNote) =>
      update(notes).replace(updatedNote);

  Future<int> deleteNote(int id) =>
      (delete(notes)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> addNote(String title, String content) =>
      into(notes).insert(NotesCompanion.insert(title: title, content: content));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    DBInfo.initialize(await getApplicationDocumentsDirectory());
    final file = File(path_dart.join(DBInfo.dir.path, DBInfo.name));
    return NativeDatabase.createInBackground(file);
  });
}


/*
For my information how it can be done:

 @Query('SELECT * FROM notes')
  Future<List<Note>> getAllNotes();

  @insert
  Future<int> insertNote(Note note);

  @update
  Future<int> updateNote(Note note);

  @delete
  Future<int> deleteNote(Note note);
*/