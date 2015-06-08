au BufNewFile,BufRead *.bb map <C-Up> :call RunAsyncCommand('bitbake ' . substitute(expand('%:t'), '_.*.bb', '', ''))<CR>
