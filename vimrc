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
let g:ycm_autoclose_preview_window_after_completion=1	"On ferme la fenêtre de preview dans YCM après avoir accepté la proposition

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

