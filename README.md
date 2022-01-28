# Skip-Char

1. A simple plugin that allows the user to type over "non-word" characters. Useful for
   typing over HTML tags (< and >), strings, parenthesis, brackets, etc.
2. Another side feature is smart semi-colon. If ; is inserted at the end of line (for languages that use ; to
   terminate a statement), a newline will automatically be inserted if the next character
   the user type is a "word" character.

### Settings

- To set a list of characters to type over, set the regex for the characters`let g:skip_chars_regex = "\[(),.;:]"`
- To set a list of characters to automatically insert a newline character if it is at the end of the line, `let g:nextline_chars_regex = "\[;]"`, default only allows for ';'
- To disable default highlight, set `let g:no_default_skip_char_highlight = 1`, or set your own highlight with `highlight SkipCharNextline guifg=#9cdcfe guibg=#444444`

### TODO:

- Allow the user to turn on/off certain features
- Allow the user to define what delimiters to skip over
