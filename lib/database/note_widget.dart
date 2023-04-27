import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'database_def.dart';

const int maxLines = 4;
const double padding = 15.0;
const double titleFontSize = 15.0;
const double contentFontSize = 11.0;
const double buttonIconSize = 18.0;

class NoteWidget extends StatefulWidget {
  final Note note;
  final Function(int, String, String) noteAction;
  final Function updateViewAction;

  const NoteWidget(
      {super.key,
      required this.note,
      required this.noteAction,
      required this.updateViewAction});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  double get width => 30;

  double availableSpaceForTitle(BoxConstraints constraints) =>
      constraints.maxWidth - buttonIconSize - 2 * padding;

  void callNoteAction() =>
      widget.noteAction(widget.note.id, widget.note.title, widget.note.content);

  void deleteNote() async {
    await Get.find<MobiNoteDatabase>().deleteNote(widget.note.id);
    widget.updateViewAction();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: const BorderSide(
          color: Colors.grey,
        ),
        minimumSize: const Size(double.infinity, 20),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
        visualDensity: VisualDensity.compact,
      ),
      onPressed: callNoteAction,
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: availableSpaceForTitle(constraints),
                      child: Text(
                        widget.note.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: buttonIconSize,
                      height: buttonIconSize,
                      child: IconButton(
                        onPressed: deleteNote,
                        icon: const Icon(Icons.clear_sharp),
                        iconSize: buttonIconSize,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Text(
                  widget.note.content,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: contentFontSize,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
