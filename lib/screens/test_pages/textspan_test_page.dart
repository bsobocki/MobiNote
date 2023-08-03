import 'package:flutter/material.dart';
import 'package:mobi_note/screens/theme/themes.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MobiNoteTheme.current.barColor,
        title: Text(
          "Test Page",
          style: TextStyle(
            fontSize: 20,
            color: MobiNoteTheme.current.textColor,
          ),
        ),
      ),
      backgroundColor: MobiNoteTheme.current.siteBackgroundColor, // _textEditingController.selection.textInside(_textEditingController.text)
      body: RichText(
        text: const TextSpan(
          children: [
            TextSpan(text: 'normally text, but this is'),
            TextSpan(
              style: TextStyle(fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: ' bold, '),
                TextSpan(
                    text: 'bold + italic',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      TextSpan(
                        text: ' italic + bold + bigger!',
                        style: TextStyle(fontSize: 26),
                      ),
                    ])
              ],
            ),
            TextSpan(text: ' so cool :)'),
          ],
        ),
      ),
    );
  }
}
