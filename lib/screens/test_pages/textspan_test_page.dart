import 'package:flutter/material.dart';

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
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        title: const Text(
          "Test Page",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(
        255,
        75,
        75,
        75,
      ), // _textEditingController.selection.textInside(_textEditingController.text)
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
