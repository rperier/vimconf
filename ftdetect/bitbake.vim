function! Bitbake(recipe, ...)
	if !a:0
		if exists("g:bitbake_default_task")
			let default_task = "-c " . g:bitbake_default_task . " "
		else
			let default_task = " "
		endif
		let cmdline = "bitbake " . default_task . a:recipe
	else
		let cmdline = "bitbake -c " . a:1 . " " . a:recipe
	endif
	call RunAsyncCommand(cmdline)
endfunction

au BufNewFile,BufRead *.{bb,bbappend,bbclass} map <C-Up> :call Bitbake(substitute(expand('%:t'), '_.*.bb*', '', ''))<CR>
au BufNewFile,BufRead *.{bb,bbappend,bbclass} command! -nargs=* Bitbake call Bitbake(<f-args>)

