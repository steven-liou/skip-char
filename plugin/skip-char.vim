" allow users to define characters to skip
if !exists('g:skip_char_skip_list')
  let g:skip_chars_regex = '\W'
endif

if !exists('g:skip_char_nextline_list')
  let g:nextline_chars_regex = "\[;]"
endif

let g:charID = 1

function CallNextline(input_char, offset)
  let next_line = 1
  if a:offset > 0
    " check if next character is also a nextline character if there is an offset
    let next_line = match(strpart(getline('.'), col('.')-1 ,1), g:nextline_chars_regex) != -1 
  endif

  let cursor_at_eol = col('.') + a:offset == col('$')
  let next_line = next_line && match(a:input_char, g:nextline_chars_regex) != -1 
  return next_line && cursor_at_eol
endfunction

function CaptureKeypress()
  silent! call matchdelete(g:charID)
  let cursor_at_eol = col('.') == col('$')
  let next_line = match(v:char, g:nextline_chars_regex) != -1 
  let skip_char = match(v:char, g:skip_chars_regex) != -1 

  if CallNextline(v:char, 0)
    let g:charID = AddSkipCharHighlight()
    augroup AutoNextline
      autocmd InsertCharPre * :call Nextline()
    augroup END
  elseif skip_char
    call SkipChar()
  endif
endfunction

function Nextline()
  autocmd! AutoNextline
  let prev_char_nextline = match(strpart(getline('.'), col('.')-2, 1), g:nextline_chars_regex) != -1

  if match(v:char, '\w') != -1 && prev_char_nextline
    let v:char = "\<CR>" . v:char
  endif
endfunction

function SkipChar()
  let input_char = v:char
  let skip_next_char = match(strpart(getline('.'), col('.')-1, 1), g:skip_chars_regex) != -1
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
  

function AddSkipCharHighlight()
  return matchaddpos('SkipCharNextline', [[line('.'), col('.'), 1], 0])
endfunction

if !exists('g:no_default_skip_char_highlight') 
  highlight SkipCharNextline guifg=#9cdcfe guibg=#444444
endif

augroup InterceptKeyPress
    autocmd!
    autocmd InsertCharPre * :call CaptureKeypress()
    autocmd InsertLeave * :silent! call matchdelete(g:charID)
    autocmd InsertLeave * :silent! autocmd! AutoNextline
augroup END
