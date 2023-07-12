class NoteWidgetData {
  final int id;
  final String type;
  final List<NoteWidgetData> children = [];

  NoteWidgetData({required this.id, required this.type});
  
  void addChild(NoteWidgetData data) {
    children.add(data);
  }
}
