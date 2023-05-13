Map<String, String> startStyleCharConversion = {
  '*': '\ue000',
  '^': '\ue002',
  '_': '\ue004',
  '~': '\ue006',
  '`': '\ue008',
  '\$': '\ue00a',
};

Map<String, String> endStyleCharConversion = {
  '*': '\ue001',
  '^': '\ue003',
  '_': '\ue005',
  '~': '\ue007',
  '`': '\ue009',
  '\$': '\ue00b',
};

Map<String, String> widgetTagConversion = {
  '(w)': '\ue100',
  '(n)': '\ue101',
  '<n>': '\ue102',
};

Map<String, String> elementPatternsConversion = {
  '[ ]': '\ue1a0',
  '[x]': '\ue1a1',
  '[i]': '\ue1a2',
};

Map<String, String> oneCharStyleMarkConversion = {
  '#': '\ue200',
  '>': '\ue201',
};

bool isStyleBoundaryCharacter(String char) {
  return startStyleCharConversion.containsKey(char);
}

bool matchesStyleStart(String context) {
  return context.length != 2 &&
      isStyleBoundaryCharacter(context[1]) &&
      !isWhitespace(context[2]);
}

bool matchesStyleEnd(String context) {
  return !isWhitespace(context[0]) && isStyleBoundaryCharacter(context[1]);
}

Iterable<String> widgetTagsStartingFrom(String char) {
  return widgetTagConversion.keys.where((e) => e[0] == char);
}

Iterable<String> elementPatternsStartingFrom(String char) {
  return elementPatternsConversion.keys.where((e) => e[0] == char);
}

bool isOneCharStyleMarkCharacter(String char) {
  return oneCharStyleMarkConversion.containsKey(char);
}

bool isWhitespace(String c) {
  return RegExp(r'\s').hasMatch(c);
}

bool isUnicodeStartSyleCharacter(String char) {
  return startStyleCharConversion.containsValue(char);
}

bool isUnicodeEndStyleCharacter(String char) {
  return endStyleCharConversion.containsValue(char);
}

bool isUnicodeOneCharStyleMarkCharacter(String char) {
  return oneCharStyleMarkConversion.containsValue(char);
}

bool isUnicodeElementPatternCharacter(String char) {
  return elementPatternsConversion.containsValue(char);
}

bool isUnicodeWidgetCharacter(String char) {
  return widgetTagConversion.containsValue(char);
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