import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_dart;

part 'database_def.g.dart';

class DBInfo {
  static Directory? _dir;
  static const String name = 'db.sqlite';

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
  TextColumn get contentFileName => text()();
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
