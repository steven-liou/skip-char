" allow users to define characters to skip
if !exists('g:skip_char_regex')
  let g:skip_char_regex = "\[>;,/|]"
endif

if !exists('g:nextline_char_regex')
  let g:nextline_char_regex = "\[;]"
endif

if !exists('g:no_default_skip_char_highlight') && !hlexists('SkipCharNextline')
  highlight SkipCharNextline guifg=#9cdcfe guibg=#444444
endif

if !exists('g:skip_char_nextline')
  let g:skip_char_nextline = 1
endif

if !exists('g:smart_enter_filetypes')
  let g:smart_enter_filetypes = ["go", "python", "ruby"]
endif


" for clearing highlight
let g:charID = 1

function! CaptureKeypress()
  silent! call matchdelete(g:charID)
  let cursor_at_eol = col('.') == col('$')
  let next_line = match(v:char, g:nextline_char_regex) != -1 
  let skip_char = match(v:char, g:skip_char_regex) != -1 

  if CallNextline(v:char, 0)
    let g:charID = AddSkipCharHighlight()
    augroup AutoNextline
      autocmd InsertCharPre * :call Nextline()
    augroup END
  elseif skip_char
    call SkipChar()
  endif
endfunction

function! Nextline()
  autocmd! AutoNextline
  " check if previous char is a newline char
  let prev_char_nextline = match(strpart(getline('.'), col('.')-2, 1), g:nextline_char_regex) != -1

  if match(v:char, '\w') != -1 && prev_char_nextline
    if index(g:smart_enter_filetypes, &ft) >= 0
      let removed_trailing_semi = substitute(starpart(getline('.'), 0), ";$", '', '')
      call setline(line('.'), removed_trailing_semi)
    endif
    let v:char = "\<CR>" . v:char
  endif
endfunction

function! CallNextline(input_char, offset)
  " if user disable automatic nextline, return immediately
  if !g:skip_char_nextline
    return 0
  endif
  " check if the current input character is a nextline char
  let next_line = match(a:input_char, g:nextline_char_regex) != -1 

  " check if next character is also a nextline character if there is an offset
  if a:offset > 0 && next_line
    let next_line = match(strpart(getline('.'), col('.')-1 ,1), g:nextline_char_regex) != -1 
  endif

  " check if only space characters exist after the nextline char
  let text_to_eol = strpart(getline('.'), col('.')-1+a:offset)
  let spaces_to_eol = match(text_to_eol, '\S') == -1

  return next_line && spaces_to_eol
endfunction

function! SkipChar()
  let input_char = v:char
  let skip_next_char = match(strpart(getline('.'), col('.')-1, 1), g:skip_char_regex) != -1
  let same_as_next_char = strpart(getline('.'), col('.')-1, 1) == input_char

  if skip_next_char && same_as_next_char
    call feedkeys("\<Right>")
    let v:char = ''
  endif

  if CallNextline(input_char, 1)
    let g:charID = AddSkipCharHighlight()
    augroup AutoNextline
      autocmd InsertCharPre * :call Nextline()
    augroup END
  endif
endfunction

  

function! AddSkipCharHighlight()
  return matchaddpos('SkipCharNextline', [[line('.'), col('.'), 1]])
endfunction


" start the plugin with autocommands
augroup InterceptKeyPress
    autocmd!
    autocmd InsertCharPre * :call CaptureKeypress()
    autocmd InsertLeave * :silent! call matchdelete(g:charID)
    autocmd InsertLeave * :silent! autocmd! AutoNextline
augroup END
