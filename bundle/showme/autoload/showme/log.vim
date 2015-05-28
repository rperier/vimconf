if !exists('g:showme_debug')
	let g:showme_debug = 0
endif

function! showme#log#info(msg)
	echomsg a:msg
endfunction

function! showme#log#warn(msg)
	echohl WarningMsg
	echomsg 'showme: warning: ' . a:msg
	echohl None
endfunction

function! showme#log#error(msg)
	echohl Error
	echomsg 'showme: error: ' . a:msg
	echohl None
endfunction

function! showme#log#debug(msg)
	if !g:showme_debug
		return
	endif
	echomsg a:msg
endfunction

