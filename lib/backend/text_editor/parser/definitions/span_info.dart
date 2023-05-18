class SpanInfo {
  String type;
  String text;
  List<SpanInfo> children;
  late SpanInfo parent;

  SpanInfo({required this.type, this.text = "", this.children = const []});
}
