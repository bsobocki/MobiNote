// import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/screens/main/homepage.dart';
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
        primaryColor: themeColor,
        unselectedWidgetColor: Colors.white,
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