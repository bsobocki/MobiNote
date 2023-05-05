import 'package:flutter/material.dart';
import 'package:mobi_note/screens/note_editor/components/obsolete/obsolete_note_element.dart';

class CheckElem extends NoteElement {
  static void defaultAction(bool e){}
  bool val = false;
  Function(bool?) setStateOnChangedAction;

  CheckElem({
    required this.setStateOnChangedAction,
  });

  void onChanged(bool? newVal) {
    val = newVal ?? false;
    setStateOnChangedAction(val);
  }

  @override
  String get json {
    return (StringBuffer('Check(')
          ..write('val: $val,')
          ..write(')'))
        .toString();
  }

  @override
  Widget get widget => Checkbox(
        onChanged: onChanged,
        value: val,
      );

  @override
  double get width => Checkbox.width;

  @override
  InlineSpan get span {
    return TextSpan(children: [
      WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: widget,
        ),
      )
    ]);
  }
}
