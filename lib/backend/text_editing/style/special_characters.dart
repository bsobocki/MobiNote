Map<String, String> specialElementConversion = {
  '(w)': 'web_link',
  '(n)': 'note_link',
  '(i)': 'image',
  '<n>': 'note_Widget',
  '[ ]': 'unselected_checkbox',
  '[x]': 'selected_checkbox',
};

Map<String, String> styleConversion = {
  '#': 'paragraph_fontSize',
  '*': 'bold',
  '^': 'italic',
  '_': 'underline',
  '~': 'strikethrough',
};

Map<String, String> styleCharOpeningConversion = {
  '#': '\ue001',
  '*': '\ue003',
  '^': '\ue005',
  '_': '\ue007',
  '~': '\ue009',
};

Map<String, String> styleCharClosureConversion = {
  '#': '\ue002',
  '*': '\ue004',
  '^': '\ue006',
  '_': '\ue008',
  '~': '\ue00a',
};

bool isElementSpecialCharacter(String char) {
  return styleConversion.containsKey(char);
}

String elementDecode(String char) {
  return styleConversion[char] ?? 'text';
}

bool isStyleSpecialCharacter(String char) {
  return styleConversion.containsKey(char);
}

bool isWhitespace(String c) {
  return RegExp(r'\s').hasMatch(c);
}

bool isMiddle(String context) {
  return !isWhitespace(context[0]) &&
        isStyleSpecialCharacter(context[1]) &&
        !isWhitespace(context[2]);
}

bool isOpening(String context) {
  return isWhitespace(context[0]) &&
      isStyleSpecialCharacter(context[1]) &&
      !isWhitespace(context[2]);
}

bool isClosure(String context) {
  return !isWhitespace(context[0]) &&
      isStyleSpecialCharacter(context[1]) &&
      isWhitespace(context[2]);
}

String styleDecode(String char) {
  return styleConversion[char] ?? 'text';
}

class StyleInfo {
  int startIndex = -1;
  int endIndex = -1;
  String style;

  StyleInfo({required this.style});

  int get start => startIndex;
  int get end => endIndex;
  set start(int newStartIndex) => startIndex = newStartIndex;
  set end(int newEndIndex) => endIndex = newEndIndex;
}

/* 

paragraph_fontSize: #size#
  example: #25#
    @size font size of the whole paragraph (TextField)
    8

web_link: (w)text:link(w)
  example: (w)some text:https://www.some.website.com(w)
    @text : visible clickable text
    @link : link to website

note_link: (n)id(n)
  example: (n)146(n)
    @id is an id in the database

image: (i)name(i)
  example: (i)capsule_tree.png(i)
    @name: name of file stored in images directory

note_widget: <n>id:width:height<n>
  example: <n>146:300:100<n>
    @id is an id in the database
    @width : widget width
    @height : widget height

may be useful sometime:

Map<String, String> specialCharConversion = {
  '\ue001': 'bold',
  '\ue002': 'italic',
  '\ue003': 'underline',
  '\ue004': 'strikethrough',
  '\ue005': 'web_link',
  '\ue006': 'note_link',
  '\ue007': 'checkbox',
  '\ue008': 'image',
  '\ue009': 'button',
  '\ue00a': 'header'
};
*/