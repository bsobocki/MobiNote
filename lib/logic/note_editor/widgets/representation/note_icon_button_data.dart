import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteIconButtonData extends NoteWidgetData {
  IconData? icon;
  double width = -1;
  double height = -1;
  double paddingLeft;
  double paddingRight;
  double paddingTop;
  double paddingBottom;
  Color? color;

  NoteIconButtonData({
    required super.id,
    this.icon,
    this.height = -1,
    this.width = -1,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.color,
    super.type = 'icon_button',
  }) {
    if (height == -1) height = paragraphDefaultFontSize;
    if (width == -1) width = paragraphDefaultFontSize;
  }

  NoteIconButtonData.fromJSON(JSON jsonObj)
      : icon = jsonObj["icon"],
        width = jsonObj["width"],
        height = jsonObj["height"],
        paddingLeft = jsonObj["paddingLeft"],
        paddingRight = jsonObj["paddingRight"],
        paddingTop = jsonObj["paddingTop"],
        paddingBottom = jsonObj["paddingBottom"],
        super.fromJSON(jsonObj);

  @override
  String get str => '{$id: image: $icon}';

  @override
  JSON get jsonAdditionalParameters => {
        "icon": icon?.codePoint,
        "width": width,
        "height": height,
        "paddingLeft": paddingLeft,
        "paddingRight": paddingRight,
        "paddingTop": paddingTop,
        "paddingBottom": paddingBottom,
        "color": color?.value
      };
}
