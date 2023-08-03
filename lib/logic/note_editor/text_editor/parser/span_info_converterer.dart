import 'package:flutter/material.dart';

import '../definitions/paragraph_textstyle_mapping/style_text_mapping.dart';
import '../definitions/span_info.dart';
import '../definitions/types/element_types.dart';
import '../definitions/types/widget_types.dart';

class SpanInfoConverter {
  SpanInfo mainSpan = SpanInfo(type: 'null');

  InlineSpan getSpans(SpanInfo spanInfo) {
    if (mainSpan.type == 'null') mainSpan = spanInfo;

    List<InlineSpan> spanChildren =
        spanInfo.children.map((e) => getSpans(e)).toList();
    var type = spanInfo.type;

    if (widgetTypes.contains(type)) {
      Widget widget = Text(spanInfo.text);
      switch (type) {
        case 'web_link':
          widget = TextButton(
            onPressed: () => debugPrint("${spanInfo.text} clicked"),
            child: Text(
              spanInfo.text,
            ),
          );
          break;

        case 'note_link':
          widget = TextButton(
            onPressed: () => debugPrint(
                "note with id: ${spanInfo.text} should be opened :D"),
            child: Text(spanInfo.text),
          );
          break;

        case 'note_widget':
          widget = ElevatedButton(
            child: Text(spanInfo.text),
            onPressed: () =>
                debugPrint("this is note ${spanInfo.text} button!"),
          );
          break;

        case 'inline_Latex':
          widget = ElevatedButton(
              onPressed: () => debugPrint("not implemented latex widget"),
              child: const Text("LaTeX"));
          break;
      }
      return WidgetSpan(child: widget);
    }

    if (elementTypes.contains(type)) {
      Widget widget = Checkbox(value: false, onChanged: (val) {});
      switch (type) {
        case 'unselected_checkbox':
          widget = Checkbox(value: false, onChanged: (val) {});
          break;
        case 'selected_checkbox':
          widget = Checkbox(value: true, onChanged: (val) {});
          break;
        case 'image':
          widget = SizedBox(
            height: textStyle(mainSpan.type).fontSize,
            child: Image.asset(spanInfo.text),
          );
          break;
      }
      return WidgetSpan(child: widget);
    }

    return TextSpan(
        text: spanInfo.text, style: textStyle(type), children: spanChildren);
  }
}
