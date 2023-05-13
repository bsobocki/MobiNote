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
