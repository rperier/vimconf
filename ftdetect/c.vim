au BufNewFile,BufRead *.{c,h} map <C-Up> :call RunAsyncCommand('make -j V=1')<CR>
