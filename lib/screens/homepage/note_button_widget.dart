import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobi_note/screens/theme/themes.dart';

import '../../database/database_def.dart';

const int maxLines = 4;
const double padding = 15.0;
const double titleFontSize = 15.0;
const double contentFontSize = 11.0;
const double buttonIconSize = 20.0;

class NoteWidget extends StatefulWidget {
  final Note note;
  final Function(Note) noteAction;
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

  void callNoteAction() => widget.noteAction(widget.note);

  void deleteNote() async {
    await Get.find<MobiNoteDatabase>().deleteNote(widget.note.id);
    widget.updateViewAction();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: MobiNoteTheme.current.buttonBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        minimumSize:
            Size(double.infinity, 20 + MobiNoteTheme.current.fontSizeAddVal),
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
            return Stack(
              children: [
                Column(
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
                            style: TextStyle(
                              fontSize: titleFontSize +
                                  MobiNoteTheme.current.fontSizeAddVal,
                              fontWeight: FontWeight.w800,
                              color: MobiNoteTheme.current.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                Divider(
                  color: MobiNoteTheme.current.textColor,
                ),
                Text(
                  widget.note.content,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:
                        contentFontSize + MobiNoteTheme.current.fontSizeAddVal,
                    color: MobiNoteTheme.current.textColor,
                  ),
                ),
              ],
            ),
                Positioned(
                  top: -7,
                  right: 10,
                  child: SizedBox(
                    width: buttonIconSize + MobiNoteTheme.current.fontSizeAddVal,
                    height: buttonIconSize + MobiNoteTheme.current.fontSizeAddVal,
                    child: IconButton(
                      onPressed: deleteNote,
                      icon: Icon(
                        Icons.clear_sharp,
                        color: MobiNoteTheme.current.textColor,
                      ),
                      iconSize:
                          buttonIconSize + MobiNoteTheme.current.fontSizeAddVal,
                    ),
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
