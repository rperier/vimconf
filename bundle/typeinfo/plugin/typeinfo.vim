let s:path = expand('<sfile>:p:h')

function! s:displayInfo(signature, len)
	let height = 1 + a:len
	let &cmdheight = height
	echohl Type
	for l in a:signature
		echo l
	endfor
	echohl None
endfunction

function! s:displayError(error)
	set cmdheight=2
	echohl Error
	echo a:error
	echohl None
endfunction

function! s:typeinfo(file)
	let result = system(s:path . "/../core/clang-typeinfo -function " . expand("<cword>") . " " . a:file . " 2>/dev/null -- -w")
	if strlen(result) != 0
		let locations = split(split(result, '\n')[0], ":")
		let beginLine = locations[1]
		let endLine = locations[2]
		let signature = readfile(locations[0])[beginLine-1:endLine-1]
		call s:displayInfo(signature, endLine - beginLine + 1)
		return 0
	endif
	return -1
endfunction

function! OpenBracket()
	let cword = expand("<cword>")

	if strlen(cword) == 0 || cword =~ '\(catch\|for\|if\|main\|switch\|while\)'
		echom "excluding cword: ". expand("<cword>")
		return
	endif

	let currentfile = expand("%p")
	let headers = split(system("grep -oE '[a-zA-Z0-9/]+\.h' " . currentfile, '\n'))
	let incpath=split(&path, ',')
	for header in headers
		for dir in incpath
			let file = dir . "/" . header
			if (!filereadable(file))
				continue
			endif
			if s:typeinfo(file) == 0
				return
			endif
		endfor
	endfor
	if s:typeinfo(currentfile) == -1	
		call s:displayError("No such pattern '". expand("<cword>") . "', missing include (or include directory) ?")
	endif
endfunction

function! CloseBracket()
	set cmdheight=1
	echo ""
endfunction

function! s:init()
	inoremap <silent> <buffer> ( <C-O>:call OpenBracket()<CR>(
	inoremap <silent> <buffer> ) <C-O>:call CloseBracket()<CR>)
endfunction
autocmd BufRead *.c call s:init()

