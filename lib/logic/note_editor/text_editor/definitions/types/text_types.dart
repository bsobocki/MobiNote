List<String> styleTypes = [
  'bold',
  'italic',
  'underline',
  'strikethrough',
  'inline_code',
];

List<String> paragraphTypes = [
  'header1',
  'header2',
  'header3',
  'header4',
  'quote',
  'latex',
  'paragraph'
];


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

image: [i]name[i]
  example: [i]capsule_tree.png[i]
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