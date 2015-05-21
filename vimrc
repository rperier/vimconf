set nocompatible			" be iMproved, required
filetype off

set autoindent  			"activer l'indentation automatique,recopie l'indentation de la ligne précèdente
set t_Co=256				"activer le mode 256 couleurs
set t_ut=				"désactiver le BCE pour faire marcher le color scheme dans tmux (http://snk.tuxfamily.org/log/vim-256color-bce.html)
set hlsearch    			"activer le highlight lors des recherches
colorscheme lapis256 			"activer le colorschme lapis256
syntax on				"activer la colorisation syntaxique
set listchars=tab:▸\ ,trail:␣,nbsp:¤	"Pour afficher les tabulations en début de ligne ou les espaces en fin de ligne
set autowriteall 			"Pour automatiquement sauvegarder les buffers modifiés lorsqu'on change de buffer

" Activation/initialisations de plugins
runtime! ftplugin/man.vim 	"Activation du plugin Man (:Man 2 printf)
call pathogen#infect()		"Initialisation de pathogen
call pathogen#helptags()

" Options pour les plugins vim

"" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_loc_list_height = 3
let g:syntastic_c_compiler = $CROSS_COMPILE . 'gcc'
let g:syntastic_c_compiler_options = $COMPILER_FLAGS.' '.$CFLAGS .' -Wall -Wextra -std=gnu99'

"" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = "murmur"
set timeoutlen=30

"" typeinfo
"let g:typeinfo_debug = 1
let g:airline#extensions#typeinfo#enabled = 1

" Mapping de raccourcis
map <C-l>     :set list!<CR>	"On utilise Ctrl-l comme toggle du mode listchars
map <C-n>     :nohlsearch<CR>	"On utilise Ctrl-n pour désactiver le hlsearch
map <C-right> :bnext<CR>	"On utilise Ctrl-right pour aller au buffer suivant
map <C-left>  :bprevious<CR>	"On utilise Ctrl-left pour aller au buffer précèdent
nnoremap K :Man <cword><CR>	"On utilise Shift-k pour lancer man sur le mot sous le curseur

" Code custom
command TmuxShell :call TmuxShell() " Définition d'une commande pour ouvrir un shell via tmux

function! _TmuxPaneIndex()
	return system("tmux display -p '#I.#P'")
endfunction

function! TmuxShell()
	if !exists("g:TmuxPaneIndex")
		call system("tmux split-window -p 30 -v")
		let g:TmuxPaneIndex = [_TmuxPaneIndex()]
	else
		call system("tmux split-window -p 50 -h -t ". g:TmuxPaneIndex[0])
		call add(g:TmuxPaneIndex, _TmuxPaneIndex())
	endif
endfunction
"Redéfinition de la commande builtin "shell" par défault à TmuxShell
cabbrev shell TmuxShell

"Lorsque l'on quitte vim, on tue le pane shell ouvert, s'il existe
function! TmuxKillShell()
	if exists("g:TmuxPaneIndex")
		for i in g:TmuxPaneIndex
			call system("tmux kill-pane -t ".i)
		endfor
	endif
endfunction
autocmd VimLeave * call TmuxKillShell()

