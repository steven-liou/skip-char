# Skip-Char

1. A simple plugin that allows the user to type over delimiter characters. Useful for
   typing over HTML tags (`>`), `,`, `;`, `|`, and `/`.

   - Default characters to skip over are characters in `[>;,/|]`
   - However, you are free to use any regex to define what charaters to skip over

2. Another side feature is smart semi-colon. If `;` is inserted at the end of line (for languages that use ";" to
   terminate a statement), a newline will automatically be inserted if the next character
   the user type is a "word" character.
   - The smart `;` will be highlighted by default when `;` is inserted at the end of the line.
   - This indicates that if the next character is alphanumeric, it will automatically be moved to the new line.
   - For programming languages that don't need `;` at end of line, the smart `;` acts as `<CR>`, so it makes going to next line easier to type. (see Settings for setting up filetypes for this behavior)

---

## Examples

- `|` represents the current cursor position

| Before                                | Type               | After                        |
| ------------------------------------- | ------------------ | ---------------------------- |
| `<div\|></div>`                       | `>`                | `<div>\|</div>`              |
| `<div>\|</>`                          | `</`               | `<div></\|>`                 |
| `let a = 1;\| (cursor is waiting...)` | `let b = 2 `       | `let a = 1;`<br> `let b = 2` |
| `let a = 1;\| (cursor is waiting...)` | `<SPACE>let b = 2` | `let a = 1; let b = 2 `      |

- Examples 1 and 2 show how typing over non-alphanumeric characters work
- Examples 3 and 4 show that after typing `;` at the end of line, if you follow up with typing a non-white space character, it will automatically insert a `<CR>` and move to the next line for you.
- If you type a whitespace character aftet `;`, then you continue on the current line

---

### Settings

- To set a list of characters to type over, set the regex for the characters
  - `let g:skip_char_regex = "\[(),.;:]"`
  - To dsiable skipping characters, you can set it to an empty regex `""`
- To set a list of characters to automatically insert a newline character if at the end of the line
  - `let g:nextline_char_regex = "\[;]"`, default allows for `;`
- To disable automatically skipping nextline
  - `let g:skip_char_nextline = 0`
  - or set regex to empty string with `let g:nextline_char_regex = ""`
- To use smart `;` as `<CR>`, you can specify the file types in a list
  - Default `let g:semi_as_enter_filetypes = ["go", "python", "ruby"]`
- To disable default highlight, set
  - `let g:no_default_skip_char_highlight = 1`,
- In addtion, you can set your own highlight with
  - `highlight SkipCharNextline guifg=#9cdcfe guibg=#444444`

---

### TODO:
