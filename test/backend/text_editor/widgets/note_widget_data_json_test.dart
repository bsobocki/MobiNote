import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/all_widget_data.dart';
import 'package:test/test.dart';

void doDataJsonTest<DataObj extends NoteWidgetData>(
    DataObj dataObj, String expectedString) {
  String jsonString = jsonEncode(dataObj.json);
  expect(jsonString, expectedString);
  expect(jsonDecode(jsonString), dataObj.json);
}

String listElementJsonStr(NoteListElementData dataObj) =>
    '{"id":${dataObj.id},"type":"list_element","children":[],"depth":${dataObj.depth},"number":${dataObj.number},"elemType":${asJsonStr(dataObj.elemType.toString())},"checkboxData":${jsonEncode(dataObj.checkboxData?.json)},"textEditorData":${jsonEncode(dataObj.textEditorData?.json)},"counterData":${jsonEncode(dataObj.counterData?.json)},"infoPageData":${jsonEncode(dataObj.infoPageData?.json)}}';

String? asJsonStr(String? str) {
  if (str != null) {
    return '"$str"';
  }
  return str;
}

void main() {
  test('json', () {
    Map<String, dynamic> obj = {
      "name": "Json",
      "surname": "Encoding",
      "id": 3,
      "isNull": false
    };

    expect(jsonEncode(obj),
        '{"name":"Json","surname":"Encoding","id":3,"isNull":false}');

    String str = '''{
      "name" : "Json",
      "surname" : "Encoding",
      "id" :  3,
      "isNull"    :false}
    ''';
    expect(jsonDecode(str), obj);
  });

  group("WidgetData objects into JSON:", () {
    test("Checkbox as JSON", () {
      List<NoteCheckboxData> dataObjs = [
        NoteCheckboxData(id: 7, value: true),
        NoteCheckboxData(id: -1),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          '{"id":${dataObj.id},"type":"checkbox","children":[],"value":${dataObj.value}}',
        );
      }
    });

    test("Counter as JSON", () {
      List<NoteCounterData> dataObjs = [
        NoteCounterData(id: 7, target: 90, count: 12),
        NoteCounterData(id: -1, target: 1),
        NoteCounterData(id: 100, target: 100, count: 12),
        NoteCounterData(id: 42, target: 34, count: 2),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          '{"id":${dataObj.id},"type":"counter","children":[],"target":${dataObj.target},"count":${dataObj.count}}',
        );
      }
    });

    test("Icon Button as JSON", () {
      List<NoteIconButtonData> dataObjs = [
        NoteIconButtonData(id: 7),
        NoteIconButtonData(id: -1, color: Colors.white),
        NoteIconButtonData(id: 100, paddingLeft: 10.0, paddingRight: 10.0),
        NoteIconButtonData(id: 42, icon: Icons.abc),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          '{"id":${dataObj.id},"type":"icon_button","children":[],"icon":${dataObj.icon?.codePoint},"width":${dataObj.width},"height":${dataObj.height},"paddingLeft":${dataObj.paddingLeft},"paddingRight":${dataObj.paddingRight},"paddingTop":${dataObj.paddingTop},"paddingBottom":${dataObj.paddingBottom},"color":${dataObj.color?.value}}',
        );
      }
    });

    test("Image as JSON", () {
      List<NoteImageData> dataObjs = [
        NoteImageData(id: 7),
        NoteImageData(id: -1, path: "this/is/path"),
        NoteImageData(id: 100, path: ""),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          '{"id":${dataObj.id},"type":"image","children":[],"path":${asJsonStr(dataObj.path)},"width":${dataObj.width},"height":${dataObj.height}}',
        );
      }
    });

    test("Info Page as JSON", () {
      List<NoteInfoPageData> dataObjs = [
        NoteInfoPageData(id: 7),
        NoteInfoPageData(id: -1),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          '{"id":${dataObj.id},"type":"info_page","children":[]}',
        );
      }
    });

    test("Label as JSON", () {
      List<NoteLabelData> dataObjs = [
        NoteLabelData(id: 7, label: 'label :)'),
        NoteLabelData(id: -1, label: 'uhuhuuu'),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          '{"id":${dataObj.id},"type":"label","children":[],"label":${asJsonStr(dataObj.label)}}',
        );
      }
    });

    test("Label as JSON", () {
      List<NoteTextEditorData> dataObjs = [
        NoteTextEditorData(id: 7, text: 'label :)'),
        NoteTextEditorData(id: -1, text: 'uhuhuuu'),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          '{"id":${dataObj.id},"type":"text_editor","children":[],"text":${asJsonStr(dataObj.text)}}',
        );
      }
    });

    test("List Element as JSON", () {
      List<NoteListElementData> dataObjs = [
        NoteListElementData(
            id: 7, depth: 0, elemType: ElementType.checkbox, number: 1),
        NoteListElementData(
            id: 8, depth: 0, elemType: ElementType.checkbox, number: 8),
        NoteListElementData(
            id: 1, depth: 0, elemType: ElementType.number, number: 101),
        NoteListElementData(
            id: 0, depth: 7, elemType: ElementType.marks, number: 32),
      ];
      for (var dataObj in dataObjs) {
        doDataJsonTest(
          dataObj,
          listElementJsonStr(dataObj),
        );
      }
    });

    test("List as JSON", () {
      List<NoteListElementData> listElems = [
        NoteListElementData(
            id: 7, depth: 0, elemType: ElementType.checkbox, number: 1),
        NoteListElementData(
            id: 8, depth: 0, elemType: ElementType.checkbox, number: 8),
        NoteListElementData(
            id: 1, depth: 0, elemType: ElementType.number, number: 101),
        NoteListElementData(
            id: 0, depth: 7, elemType: ElementType.marks, number: 32),
      ];
      var dataObj = NoteListData(
          id: 109, elements: listElems, elemType: ElementType.number);
      String elemsJsonStr = '';

      for (int i = 0; i < listElems.length-1; i++) {
        elemsJsonStr += '${listElementJsonStr(listElems[i])},';
      }
      elemsJsonStr += listElementJsonStr(listElems.last);
      doDataJsonTest(
        dataObj,
        '{"id":${dataObj.id},"type":"list","children":[],"elemType":"${dataObj.elemType.toString()}","elements":[$elemsJsonStr]}',
      );
    });
  });
}
