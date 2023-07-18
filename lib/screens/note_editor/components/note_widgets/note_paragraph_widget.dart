import 'package:flutter/material.dart';
import 'package:mobi_note/logic/helpers/call_if_not_null.dart';
import 'package:mobi_note/screens/note_editor/components/note_paragraph.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteParagraphWidget extends NoteParagraph {
  String widgetJSON;
  WidgetMode mode = WidgetMode.show;
  final List<NoteEditorWidget> elements;

  NoteParagraphWidget(
      {required super.id,
      required super.reportFocusParagraph,
      required this.widgetJSON,
      this.elements = const []})
      : super(key: ValueKey("NoteParagraphWidget_$id"));

  late void Function(WidgetMode mode)? setMode;
  void Function()? requestFocus;

  @override
  State<NoteParagraphWidget> createState() => _NoteParagraphWidgetState();
}

class _NoteParagraphWidgetState extends State<NoteParagraphWidget> {
  late List<Widget> elements;
  FocusNode focusNode = FocusNode();

  void setMode(WidgetMode mode) => setState(() {
    debugPrint("mode set to: ${mode == WidgetMode.edit ? 'edit' : 'other'}");
        widget.mode = mode;
        for (var elem in widget.elements) {
          elem.setMode(mode);
        }
      });

  void foucusAction() {
    if (focusNode.hasFocus) {
      widget.reportFocusParagraph(widget.id);
    } else {}
  }

  @override
  void initState() {
    super.initState();
    elements = widget.elements;
    widget.requestFocus = () => focusNode.requestFocus();
    widget.setMode = setMode;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        widget.setMode!(WidgetMode.edit);
      } else {
        widget.setMode!(WidgetMode.show);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: Row(
        children: elements,
      ),
    );
  }
}
