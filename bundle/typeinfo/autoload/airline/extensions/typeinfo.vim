" MIT License. Copyright (c) 2015 Romain Perier.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#typeinfo#init(ext)
  "call airline#parts#define_raw('typeinfo', '%{airline#extensions#typeinfo#get_status()}')
  "call a:ext.add_statusline_func('airline#extensions#typeinfo#apply')
  call airline#parts#define_function('typeinfo', 'airline#extensions#typeinfo#get_status') 
  let g:airline_section_warning = airline#section#create(['typeinfo', 'syntastic', 'whitespace'])
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#typeinfo#apply(...)
  if !exists('b:airline_typeinfo_check')
    let g:airline_section_warning .= airline#section#create(['typeinfo'])
    let b:airline_typeinfo_check = 1
  endif
endfunction

" Finally, this function will be invoked from the statusline.
function! airline#extensions#typeinfo#get_status()
  return  typeinfo#StatusLineFlag()
endfunction

