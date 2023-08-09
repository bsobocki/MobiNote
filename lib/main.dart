// import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/screens/homepage/homepage.dart';
import 'database/database_def.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(MobiNoteDatabase());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MobiNote',
      home: MyHomePage(title: 'MobiNote'),
    );
  }
}
