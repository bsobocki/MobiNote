Map<String, String> tagConversion = {
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
  '>': 'quote',
  '`': 'one_line_code',
  '\$': 'one_line_latex',
};

Map<String, String> startStyleCharConversion = {
  '#': '\ue000',
  '*': '\ue002',
  '^': '\ue004',
  '_': '\ue006',
  '~': '\ue008',
  '>': '\ue00a',
  '`': '\ue00c',
  '\$': '\ue00e',
};

Map<String, String> endStyleCharConversion = {
  '#': '\ue001',
  '*': '\ue003',
  '^': '\ue005',
  '_': '\ue007',
  '~': '\ue009',
  '>': '\ue00b',
  '`': '\ue00d',
  '\$': '\ue00f',
};

Map<String, String> elementPattenrConversion = {
  '[ ]': '\ue104',
  '[x]': '\ue105',
};

Map<String, String> widgetTagConversion = {
  '(w)': '\ue200',
  '(n)': '\ue201',
  '(i)': '\ue202',
  '<n>': '\ue203',
};

Iterable<String> elementPatternsStartingFrom(String char) {
  return elementPattenrConversion.keys.where((e) => e[0] == char);
}

bool isElementPattern(String char) {
  return elementPattenrConversion.containsKey(char);
}

bool isWidgetTag(String char) {
  return widgetTagConversion.containsKey(char);
}

bool isWidgetTagStartCharacter(char) {
  return widgetTagConversion.keys.where((e) => e == char).isNotEmpty;
}

String elementDecode(String char) {
  return styleConversion[char] ?? 'text';
}

bool isStyleBoundaryCharacter(String char) {
  return styleConversion.containsKey(char);
}

bool isWhitespace(String c) {
  return RegExp(r'\s').hasMatch(c);
}

bool matchesStyleStart(String context) {
  return context.length != 2 &&
      isStyleBoundaryCharacter(context[1]) &&
      !isWhitespace(context[2]);
}

bool matchesStyleEnd(String context) {
  return !isWhitespace(context[0]) && isStyleBoundaryCharacter(context[1]);
}

String styleDecode(String char) {
  return styleConversion[char] ?? 'text';
}

class SpecialCharInfo {
  final int index;
  final String char;

  SpecialCharInfo({required this.index, required this.char});
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
widget tags don't have to check context to find out whether it is start or end
because after first new occurrence there have to be the next one as end
of widget

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