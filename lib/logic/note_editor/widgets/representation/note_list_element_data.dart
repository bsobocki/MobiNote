import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/all_widget_data.dart';

import 'note_checkbox_data.dart';
import 'note_counter_data.dart';
import 'note_info_page_data.dart';
import 'note_text_editor_data.dart';
import 'note_widget_data.dart';

enum ElementType { checkbox, number, marks, counter, custom }

ElementType decodeElemType(JSON jsonObj) =>
    ElementType.values.firstWhere((e) => e.toString() == jsonObj['elemType']);

class NoteListElementData extends NoteWidgetData {
  int depth;
  int number;
  ElementType elemType;
  NoteCheckboxData? checkboxData;
  NoteTextEditorData? textEditorData;
  NoteCounterData? counterData;
  NoteInfoPageData? infoPageData;

  NoteListElementData({
    required super.id,
    required this.depth,
    required this.elemType,
    required this.number,
    this.checkboxData,
    this.textEditorData,
    this.counterData,
    this.infoPageData,
    super.type = 'list_element',
  }) {
    if (elemType == ElementType.checkbox) {
      checkboxData ??= NoteCheckboxData(id: -1);
    }
    textEditorData ??= NoteTextEditorData(id: id, text: '');
  }

  NoteListElementData.fromJSON(JSON jsonObj)
      : depth = jsonObj["depth"],
        number = jsonObj["number"],
        elemType = ElementType.checkbox,
        checkboxData = null,
        textEditorData = null,
        counterData = null,
        infoPageData = null,
        super.fromJSON(jsonObj) {
    elemType = decodeElemType(jsonObj);
    if (jsonObj["checkboxData"] != null) {
      checkboxData = createData(jsonObj["checkboxData"]) as NoteCheckboxData;
    }
    if (jsonObj["textEditorData"] != null) {
      textEditorData =
          createData(jsonObj["textEditorData"]) as NoteTextEditorData;
    }
    if (jsonObj["counterData"] != null) {
      counterData = createData(jsonObj["counterData"]) as NoteCounterData;
    }
    if (jsonObj["infoPageData"] != null) {
      infoPageData = createData(jsonObj["infoPageData"]) as NoteInfoPageData;
    }
  }

  String getStrIfNotNull(NoteWidgetData? data) {
    if (data != null) {
      return data.str;
    }
    return '';
  }

  @override
  String get str {
    String s = '${'  ' * (depth + 1)}{$id: elem: ';
    s += getStrIfNotNull(checkboxData);
    s += getStrIfNotNull(textEditorData);
    s += getStrIfNotNull(counterData);
    s += getStrIfNotNull(infoPageData);
    return '$s }';
  }

  @override
  JSON get jsonAdditionalParameters => {
        "depth": depth,
        "number": number,
        "elemType": elemType.toString(),
        "checkboxData": checkboxData?.json,
        "textEditorData": textEditorData?.json,
        "counterData": counterData?.json,
        "infoPageData": infoPageData?.json,
      };
}
