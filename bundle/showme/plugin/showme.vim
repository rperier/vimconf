let s:path = expand('<sfile>:p:h')
let s:c_flags = ''
let s:include_dirs = ''
let s:statusline = ''

function! s:displayInfo(signature, len)
	let height = 1 + a:len
	let &cmdheight = height
	echohl Type
	for l in a:signature
		echo l
	endfor
	echohl None
endfunction

function! s:parseConfig()
	let c_flags = []
	let include_dirs = []
	let config = findfile(".syntastic_c_config", '.;')
	if config ==# ''
		call showme#log#debug("config file not found")
		return
	endif
	let lines = readfile(config)
	" Remove empty lines and comments
	call filter(lines, 'v:val !~# ''\v^(\s*#|$)''')
	for line in lines
		if line =~ '^-I.*$' && strlen(line[2:])
			call add(include_dirs, line[2:])
		else
			call add(c_flags, line)
		endif
	endfor
	let s:c_flags = join(c_flags, ' ')
	let s:include_dirs = join(map(include_dirs, '"-I" .v:val'), ' ')
endfunction

function! s:showme(file, mode)
	let cmd = fnamemodify(s:path . "/../core/clang-showme", ":p") . " -" . a:mode . " " . expand("<cword>") . " " . a:file . " 2>/dev/null -- -w " . s:c_flags . " " . s:include_dirs
	call showme#log#debug("launching: " . cmd)
	let result = system(cmd)
	call showme#log#debug("result: " . result)
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

function! ShowMeFunc()
	let cword = expand("<cword>")

	if cword !~ '\<[A-Z_a-z0-9]\+\>' || cword =~ '\(^catch$\|^for$\|^if$\|^main$\|^sizeof$\|^switch$\|^while$\)'
		call showme#log#debug("excluding invalid cword: ". expand("<cword>"))
		return
	endif

	normal b
	let currentline = getline('.')
	let pos = getpos('.')
	let index = pos[2] - 2
	while index > 0 && (currentline[index] == ' ' || currentline[index] == '\t')
		call showme#log#debug('col[' . (index) . '] = ' . currentline[index])
		let index -= 1
	endwhile
	call setpos('.', pos)
	normal e
	if index > 0
		call showme#log#debug('function definition, ignoring')
		return
	endif

	let currentfile = expand("%p")
	if cword =~ '\<[A-Z_0-9]\+\>'
		if s:showme(currentfile, "macro") == -1
			let s:statusline = "Macro not found"
			return
		endif
	else
		if s:showme(currentfile, "function") == -1
			if s:showme(currentfile, "macro") == -1
				let s:statusline = "Function or macro not found"
				return
			endif
		endif
	endif
	let s:statusline = ''
endfunction

function! CloseBracket()
	set cmdheight=1
	echo ""
	let s:statusline = ''
endfunction

function! showme#StatusLineFlag()
	return s:statusline
endfunction

function! s:init()
	call s:parseConfig()
	let s:include_dirs = s:include_dirs . ' ' . join(map(filter(split(&path, ','), 'v:val !=# ""'), '"-I" .v:val'), ' ')
	inoremap <silent> <buffer> ( <C-O>:call ShowMeFunc()<CR>(
	inoremap <silent> <buffer> ) <C-O>:call CloseBracket()<CR>)
endfunction
autocmd BufRead *.c call s:init()

