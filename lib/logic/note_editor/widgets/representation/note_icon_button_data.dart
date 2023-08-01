import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteIconButtonData extends NoteWidgetData {
  IconData? icon;
  double width;
  double height;
  double paddingLeft;
  double paddingRight;
  double paddingTop;
  double paddingBottom;
  Color? color;

  NoteIconButtonData({
    required super.id,
    this.icon,
    this.height = paragraphDefaultFontSize,
    this.width = paragraphDefaultFontSize,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.color,
    super.type = 'icon_button',
  });

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
