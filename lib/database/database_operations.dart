import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_dart;

import 'database_def.dart';

Future<void> rebuildDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(path_dart.join(dir.path, 'mobinote_db.sqlite'));
    
    // Close the database connection if it's open
    await MobiNoteDatabase().close();
    Get.delete<MobiNoteDatabase>();
    
    // Delete the existing database file
    await file.delete();
    
    // Recreate the database and open a new connection
    Get.put(MobiNoteDatabase());
  }