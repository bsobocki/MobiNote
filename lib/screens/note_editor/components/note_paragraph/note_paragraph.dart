import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class NoteParagraph extends StatefulWidget {
  final int id;
  void Function(int) reportFocusParagraph;
  void Function(int) deleteParagraph;

  void Function()? requestFocusInState;

  void requestFocus() {
    if (requestFocusInState != null) {
      requestFocusInState!();
    } else {
      debugPrint('requestFocus in state id NULL!!!!!!!');
    }
  }

  void setDefaultCallbacks() {
    requestFocusInState = null;
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
