au BufNewFile,BufRead *.{c,h} map <Leader>b :call RunAsyncCommand('make -j V=1')<CR>
au BufNewFile,BufRead *.{c,h} command! -nargs=* GDB ConqueGdb <f-args>
