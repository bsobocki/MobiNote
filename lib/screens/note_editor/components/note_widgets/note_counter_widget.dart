import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobi_note/logic/note_editor/text_editor/constants/text_style_properties.dart';
import 'package:mobi_note/logic/note_editor/widgets/representation/note_counter_data.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/definitions/widget_mode.dart';
import 'package:mobi_note/screens/note_editor/components/note_widgets/note_widget.dart';

class NoteCounterWidget extends NoteEditorWidget {
  NoteCounterData data;

  void Function()? onResetCounter;
  void Function()? onTargetReached;

  NoteCounterWidget(
      {super.key,
      required super.id,
      required this.data,
      this.onResetCounter,
      this.onTargetReached,
      super.onLongPress,
      super.focusOffAction,
      super.focusOnAction,
      super.onInteract,
      super.removeFromParent,
      super.mode});

  bool get targetReached {
    return data.count >= data.targetValue;
  }

  @override
  State<NoteCounterWidget> createState() => _NoteCounterWidgetState();
}

class _NoteCounterWidgetState extends State<NoteCounterWidget> {
  TextEditingController controller = TextEditingController();

  void resetCounter() {
    widget.onResetCounter?.call();
    widget.data.count = 0;
  }

  Widget get counterWidget {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: ElevatedButton(
        onPressed: () => setState(() {
          widget.data.count++;
          if (widget.targetReached) {
            widget.onTargetReached?.call();
          }
        }),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(0)),
        onLongPress: widget.onLongPress,
        child: Row(
          children: [
            Text(
              '${widget.data.count} / ',
              style: TextStyle(
                color: widget.targetReached ? Colors.grey[700] : Colors.white,
              ),
            ),
            IntrinsicWidth(
              child: TextField(
                  onTap: () => controller.text = '',
                  controller: controller
                    ..text = widget.data.targetValue.toString(),
                  onSubmitted: (text) => setState(() {
                        widget.data.targetValue =
                            int.tryParse(text) ?? widget.data.targetValue;
                        resetCounter();
                        widget.mode = WidgetMode.edit;
                      }),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.grey[700]),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return counterWidget;
  }
}
