" MIT License. Copyright (c) 2015 Romain Perier.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#showme#init(ext)
  call airline#parts#define_function('showme', 'airline#extensions#showme#get_status') 
  let g:airline_section_warning = airline#section#create(['showme', 'syntastic', 'whitespace'])
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#showme#apply(...)
  if !exists('b:airline_showme_check')
    let g:airline_section_warning .= airline#section#create(['showme'])
    let b:airline_showme_check = 1
  endif
endfunction

" Finally, this function will be invoked from the statusline.
function! airline#extensions#showme#get_status()
  return  showme#StatusLineFlag()
endfunction

