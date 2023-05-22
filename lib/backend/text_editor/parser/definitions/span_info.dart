class SpanInfo {
  String type;
  String text;
  List<SpanInfo> children;
  late SpanInfo parent;

  SpanInfo({required this.type, this.text = "", this.children = const []});

  String get childrenStr {
    List<String> string = [];
    for (int i = 0; i < children.length; i++) {
      string += [children[i].str];
    }
    return string.join('');
  }

  String get strWithoutChildren =>
      '{type: $type, text: $text, children: ${children.isEmpty? "[]": "[...]"} }';

  String get str => '\n{type: $type, text: $text, children: [$childrenStr] }';
}
