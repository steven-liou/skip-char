function CaptureKeypress()
  let s:next_line_chars_regex = "\[;]" 
  let s:skip_chars_regex = "\[;<>]"
  let s:cursor_at_eol = col(".") == col("$")
  let s:next_line = match(v:char, s:next_line_chars_regex) != -1 
  let s:skip_char = match(v:char, s:skip_chars_regex) != -1 

  if s:next_line && s:cursor_at_eol
    augroup AutoNextline
      autocmd InsertCharPre * :call Nextline(s:next_line_chars_regex)
    augroup END
  elseif s:skip_char
    call SkipChar(s:skip_chars_regex)
  endif
endfunction

function Nextline(capture_chars_regex)
  autocmd! AutoNextline
  let prev_char_is_capture_chars = match(strpart(getline('.'), col('.')-2, 1), a:capture_chars_regex) != -1

  if match(v:char, '\w') != -1 && prev_char_is_capture_chars
    let v:char = "\<CR>" . v:char
  endif
endfunction

function SkipChar(capture_chars_regex)
  echom  match(strpart(getline('.'), col('.')-1, 1), a:capture_chars_regex)
  let s:skip_next_char = match(strpart(getline('.'), col('.')-1, 1), a:capture_chars_regex) != -1
  if s:skip_next_char
    call feedkeys("\<Right>")
    let v:char = ""
  endif
endfunction
  
augroup InterceptKeyPress
    autocmd!
    autocmd InsertCharPre * :call CaptureKeypress()
augroup END
