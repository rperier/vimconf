if !exists('g:typeinfo_debug')
	let g:typeinfo_debug = 0
endif

function! typeinfo#log#info(msg)
	echomsg a:msg
endfunction

function! typeinfo#log#warn(msg)
	echohl WarningMsg
	echomsg 'typeinfo: warning: ' . a:msg
	echohl None
endfunction

function! typeinfo#log#error(msg)
	echohl Error
	echomsg 'typeinfo: error: ' . a:msg
	echohl None
endfunction

function! typeinfo#log#debug(msg)
	if !g:typeinfo_debug
		return
	endif
	echomsg a:msg
endfunction

