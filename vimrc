set nocompatible			" be iMproved, required
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#begin()
Bundle 'gmarik/vundle'
Bundle 'vim-scripts/Conque-GDB'
Bundle 'Firef0x/PKGBUILD.vim'
Bundle 'rking/ag.vim'
Bundle 'bling/vim-airline'
Bundle 'kergoth/vim-bitbake'
Bundle 'bling/vim-bufferline'
Bundle 'gregsexton/gitv'
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'
Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/syntastic'
Bundle 'edkolev/tmuxline.vim'
Bundle 'kien/ctrlp.vim'
Plugin 'cmake', {'pinned': 1}
Plugin 'xtermkeys', {'pinned': 1}
Plugin 'showme', {'pinned': 1}
call vundle#end()
filetype plugin indent on

" Options standard de vim
set autoindent  			"activer l'indentation automatique,recopie l'indentation de la ligne précèdente
set t_Co=256				"activer le mode 256 couleurs
set t_ut=				"désactiver le BCE pour faire marcher le color scheme dans tmux (http://snk.tuxfamily.org/log/vim-256color-bce.html)
set hlsearch    			"activer le highlight lors des recherches
colorscheme lapis256 			"activer le colorschme lapis256
syntax on				"activer la colorisation syntaxique
set listchars=tab:▸\ ,trail:␣,nbsp:¤	"Pour afficher les tabulations en début de ligne ou les espaces en fin de ligne
set autowriteall 			"Pour automatiquement sauvegarder les buffers modifiés lorsqu'on change de buffer
set pastetoggle=<F2>			"Pour activer/desactiver le mode paste afin de ne pas casser l'indentation à cause de autoindent
set lazyredraw				"On postpone la plupart des redraw que lorsque c'est explicitement necessaire (réduit la charge graphique)
set ttyfast				"Indique qu'il s'agit d'un terminal rapide, plus de caractères sont envoyés lors du redraw, ça améliore le smoothing
set laststatus=2			"Toujours afficher la barre de status (pour airline)
set previewheight=24			"Hauteur de la preview window que l'on double (12 par défaut)
let mapleader = ','			"On définie le prefix key ou leader à ','

" Activation/initialisations de plugins
runtime! ftplugin/man.vim 	"Activation du plugin Man (:Man 2 printf)


" Options pour les plugins vim
let g:airline_powerline_fonts = 1
let g:airline_theme = "murmur"
set timeoutlen=30

"" showme
"let g:showme_debug = 1
let g:airline#extensions#showme#enabled = 1

"" bufferline
let g:bufferline_echo = 0

"" conque
let g:ConqueTerm_TERM = 'xterm'
let g:ConqueTerm_Color = 1

" Mapping de raccourcis
map <C-l>     :set list!<CR>	"On utilise Ctrl-l comme toggle du mode listchars
map <C-n>     :nohlsearch<CR>	"On utilise Ctrl-n pour désactiver le hlsearch
map <C-right> :bnext<CR>	"On utilise Ctrl-right pour aller au buffer suivant
map <C-left>  :bprevious<CR>	"On utilise Ctrl-left pour aller au buffer précèdent
nnoremap K :Man <cword><CR>	"On utilise Shift-k pour lancer man sur le mot sous le curseur

" Code custom
function! RunAsyncCommand(cmdline)
	below new
	resize 20
	call conque_term#open(a:cmdline)
endfunction

function! OpenTodo()
	let l:path = findfile("TODO.txt", ".;")
	execute 'pedit' l:path
	wincmd p
endfunction

command! Todo call OpenTodo()
