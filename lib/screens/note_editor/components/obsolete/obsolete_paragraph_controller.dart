import 'package:flutter/material.dart';

bool val = true;

class ParagraphController extends TextEditingController {
  late final Pattern pattern;
  final Map<String, InlineSpan> mapping = {
    '\ufffa': TextSpan(children: [
      WidgetSpan(
        child: SizedBox(
            width: 300,
            height: 300,
            child: Image.asset('images/capsule_tree.png')),
      ),
    ]),
    '\ufffe': TextSpan(
      children: [
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: SizedBox(
              width: Checkbox.width,
              height: Checkbox.width,
              child: Checkbox(
                onChanged: (val) {},
                value: val,
                activeColor: Colors.transparent,
                checkColor: Colors.grey,
                focusColor: Colors.white,
                hoverColor: Colors.white,
              ),
            ),
          ),
        )
      ],
    ),
    '\uffff': const TextSpan(
      children: [
        WidgetSpan(
          child: SizedBox(
            child: Icon(Icons.flutter_dash),
          ),
        )
      ],
    ),
    '\ufffb': TextSpan(
      children: [
        WidgetSpan(
          style: const TextStyle(fontSize: 30),
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () => debugPrint("something"),
              child: const Text("kliknij"),
            ),
          ),
        )
      ],
    ),
    '<red>.*<red>': const TextSpan(
      style: TextStyle(color: Colors.red),
      text: 'to jest czerwony wstawiony text',
    )
  };

  ParagraphController() {
    pattern = RegExp(mapping.keys.map((key) => RegExp.escape(key)).join('|'));
  }

  String getContent(Match match) {
    

    return '';
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    List<InlineSpan> children = [];
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        var matchedText = match[0];
        var matchContent = getContent(match);

        children.add(mapping[match[0]] ?? const TextSpan(text: "failed"));
        return "";
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return "";
      },
    );
    return TextSpan(style: style, children: children);
  }
}
