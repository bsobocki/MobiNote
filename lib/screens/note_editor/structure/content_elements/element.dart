import 'package:flutter/material.dart';

const double noteContentDefaultFontSize = 16.0;

abstract class NoteElement {
  String get json;
  double get width;
  InlineSpan get span;
}

// class RowElem extends NoteElement {
//   List<NoteElement> elements;

//   RowElem({required this.elements});

//   int get length => elements.length;
//   NoteElement get last => elements.last;
//   List<NoteElement> get allElements => elements;
//   set elementsList(List<NoteElement> newList) => elements = newList;
//   void add(NoteElement element) => elements.add(element);
//   void insert(int index, NoteElement element) =>
//       elements.insert(index, element);
//   void insertAll(int index, Iterable<NoteElement> manyElements) =>
//       elements.insertAll(index, manyElements);

//   @override
//   String get json {
//     String elementsJson = elements.map((elem) => elem.json).join(', ');
//     return 'Row($elementsJson)';
//   }

//   @override
//   Widget get widget {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: elements.map((elem) => elem.widget).toList()
//         ..add(SpaceElem().widget),
//     );
//   }

//   @override
//   double get width => elements.fold(0, (sum, element) => sum + element.width);
// }

// class TextElem extends NoteElement {
//   final String text;
//   final TextStyle style;
//   // Function(dynamic) onTap;

//   TextElem({required this.text, required this.style});

//   @override
//   String get json => (StringBuffer('Text(')
//         ..write('text: $text, ')
//         ..write('style: $style, ')
//         ..write(')'))
//       .toString();

//   @override
//   InlineSpan get widget {
//     return GestureDetector(
//       onTap: () => debugPrint("tap on $text"),
//       child: Text(
//         text,
//         style: style,
//       ),
//     );
//   }

//   @override
//   double get width {
//     final textSpan = TextSpan(text: text, style: style);
//     final textPainter = TextPainter(
//       text: textSpan,
//       textDirection: TextDirection.ltr,
//     )..layout();

//     return textPainter.width;
//   }
// }

// class EditedTextElem extends NoteElement {
//   late double _width;
//   final TextStyle style;
//   final _editingController = TextEditingController();
//   Function(String value) onChanged;
//   bool isActive = true;

//   EditedTextElem(
//       {required String text, required this.style, required this.onChanged}) {
//     _editingController.text = text;
//     _width = style.fontSize ?? noteContentDefaultFontSize;
//   }

//   bool get active => isActive;
//   set active(bool val) => isActive = val;
//   String get text => _editingController.text;

//   void onChangedCall(String val) {
//     debugPrint("text: $text, val: $val");
//     _width = textWidth;
//     onChanged(val);
//   }

//   @override
//   String get json {
//     return (StringBuffer('Text(')
//           ..write('text: $text, ')
//           ..write('style: $style, ')
//           ..write(')'))
//         .toString();
//   }

//   TextEditingController get editingController => _editingController;

//   @override
//   Widget get widget {
//     return SizedBox(
//       width: _width,
//       child: TextField(
//         controller: _editingController,
//         style: style,
//         decoration: const InputDecoration(
//           contentPadding:
//               EdgeInsets.all(0), // Remove the default content padding
//           enabledBorder: InputBorder.none, // Remove the border
//         ),
//         onChanged: onChangedCall,
//       ),
//     );
//   }

//   @override
//   double get width => _width;

//   double get textWidth {
//     final textSpan = TextSpan(text: editingController.text, style: style);
//     final textPainter = TextPainter(
//       text: textSpan,
//       textDirection: TextDirection.ltr,
//     )..layout();

//     debugPrint("textWidth is called and returns: ${textPainter.width}");
//     return textPainter.width;
//   }
// }

// class IconElem extends NoteElement {
//   final IconData icon;

//   IconElem({required this.icon});

//   @override
//   String get json {
//     return (StringBuffer('Image(')
//           ..write('icon: $icon, ')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   Widget get widget {
//     return Icon(icon);
//   }

//   @override
//   double get width => SizedBox(
//         child: widget,
//       ).width!;
// }

// class ImageElem extends NoteElement {
//   final String path;

//   ImageElem({required this.path});

//   @override
//   String get json {
//     return (StringBuffer('Image(')
//           ..write('path: $path, ')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   Widget get widget {
//     return Image.asset(path);
//   }

//   @override
//   double get width => (widget as Image).width!;
// }
