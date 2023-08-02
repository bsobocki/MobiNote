typedef JSON = Map<String, dynamic>;

abstract class NoteWidgetData {
  final int id;
  final String type;
  final List<NoteWidgetData> children = [];

  NoteWidgetData({required this.id, required this.type});
  NoteWidgetData.fromJSON(JSON jsonObj)
      : id = jsonObj["id"],
        type = jsonObj["type"];

  JSON get jsonAdditionalParameters;
  String get str;

  void addChild(NoteWidgetData data) {
    children.add(data);
  }

  List<JSON> get jsonChildren {
    List<JSON> childrenJSON = [];
    for (var elem in children) {
      childrenJSON.add(elem.json);
    }
    return childrenJSON;
  }

  JSON get json => {
        "id": id,
        "type": type,
        "children": jsonChildren,
      }..addAll(jsonAdditionalParameters);
}
