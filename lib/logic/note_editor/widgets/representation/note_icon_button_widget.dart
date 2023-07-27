import 'package:flutter/material.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_widget_data.dart';

class NoteIconButtonData extends NoteWidgetData {
  IconData? icon;
  double width;
  double height;

  NoteIconButtonData({
    required super.id,
    this.icon,
    this.height = paragraphDefaultFontSize,
    this.width = paragraphDefaultFontSize,
    super.type = 'image',
  });

  @override
  String get str => '{$id: image: $icon}';
}
