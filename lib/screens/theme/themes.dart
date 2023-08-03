import 'package:flutter/material.dart';

enum NoteScreenThemes { dark, light, easy }

class NoteScreenTheme {
  Color siteBackgroundColor;
  Color buttonBackgroundColor;
  Color unselectedButtonColor;
  Color barColor;
  Color textColor;
  double fontSizeAddVal;

  NoteScreenTheme({
    required this.siteBackgroundColor,
    required this.buttonBackgroundColor,
    required this.unselectedButtonColor,
    required this.barColor,
    required this.textColor,
    required this.fontSizeAddVal,
  });
}

NoteScreenTheme darkTheme = NoteScreenTheme(
  siteBackgroundColor: const Color.fromARGB(255, 49, 49, 49),
  buttonBackgroundColor: const Color.fromARGB(255, 73, 73, 73),
  unselectedButtonColor: Colors.grey[500]!.withOpacity(0.7),
  barColor: Colors.grey[900]!,
  textColor: Colors.white,
  fontSizeAddVal: 0.0,
);

NoteScreenTheme lightTheme = NoteScreenTheme(
  siteBackgroundColor: Colors.grey[200]!,
  buttonBackgroundColor: Colors.grey[400]!,
  unselectedButtonColor: Colors.grey[500]!,
  barColor: Colors.grey[600]!,
  fontSizeAddVal: 0,
  textColor: Colors.black,
);

NoteScreenTheme easyTheme = NoteScreenTheme(
  siteBackgroundColor: Colors.white,
  buttonBackgroundColor: Colors.yellow[800]!,
  unselectedButtonColor: Colors.yellow[500]!,
  barColor: Colors.grey[200]!,
  fontSizeAddVal: 8.0,
  textColor: Colors.black,
);

class MobiNoteTheme {
  static NoteScreenTheme currentTheme = darkTheme;

  static void Function()? refreshAppState;

  static NoteScreenTheme get current {
    return currentTheme;
  }

  static void setTheme(NoteScreenThemes theme) {
    switch (theme) {
      case NoteScreenThemes.dark:
        currentTheme = darkTheme;
        break;
      case NoteScreenThemes.light:
        currentTheme = lightTheme;
        break;
      case NoteScreenThemes.easy:
        currentTheme = easyTheme;
        break;
    }
  }
}
