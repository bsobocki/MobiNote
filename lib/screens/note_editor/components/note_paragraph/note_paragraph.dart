import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';

// ignore: must_be_immutable
abstract class NoteParagraph extends StatefulWidget {
  final int id;
  void Function()? requestFocusInState;
  void Function(int) reportFocusParagraph;
  void Function(int) deleteParagraph;

  void requestFocus() {
    if (requestFocusInState != null) {
      requestFocusInState!();
    }
  }

  NoteParagraph({
    super.key,
    required this.id,
    required this.reportFocusParagraph,
    required this.deleteParagraph,
  });

  String get text;
  int get rawLength;
  String get widgetTree;
  String get str;
}
