au BufNewFile,BufRead PKGBUILD command! -nargs=* MakePkg call RunAsyncCommand("makepkg -s")

