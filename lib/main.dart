// import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/screens/homepage/homepage.dart';
import 'package:mobi_note/screens/theme/themes.dart';
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
    return MaterialApp(
      title: 'MobiNote',
      theme: ThemeData(
        //primaryColor: MobiNoteTheme.current.buttonBackgroundColor,
        //unselectedWidgetColor: MobiNoteTheme.current.buttonBackgroundColor,
        //floatingActionButtonTheme:
        //    FloatingActionButtonThemeData(backgroundColor: MobiNoteTheme.current.buttonBackgroundColor),
        //dialogBackgroundColor: themeColor,
        //bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //    backgroundColor: MobiNoteTheme.current.barColor,
        //    unselectedItemColor: Colors.grey,
        //    selectedItemColor: Colors.white),
      ),
      home: const MyHomePage(title: 'MobiNote'),
    );
  }
}
