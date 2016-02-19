filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#begin()
Bundle 'gmarik/vundle'
Bundle 'vim-scripts/Conque-GDB'
Bundle 'Firef0x/PKGBUILD.vim'
Bundle 'rking/ag.vim'
Bundle 'freeo/vim-kalisi'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'kergoth/vim-bitbake'
Bundle 'gregsexton/gitv'
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'
Bundle 'msanders/snipmate.vim'
Bundle 'edkolev/tmuxline.vim'
Bundle 'kassio/neoterm'
Bundle 'kien/ctrlp.vim'
Plugin 'cmake', {'pinned': 1}
Plugin 'xtermkeys', {'pinned': 1}
Plugin 'showme', {'pinned': 1}
call vundle#end()
filetype plugin indent on

" Options standard de vim
set autoindent  			"activer l'indentation automatique,recopie l'indentation de la ligne précèdente
set hlsearch    			"activer le highlight lors des recherches
colorscheme kalisi 			"activer le colorscheme kalisi dark
set background=dark
syntax on				"activer la colorisation syntaxique
set listchars=tab:▸\ ,trail:␣,nbsp:¤	"Pour afficher les tabulations en début de ligne ou les espaces en fin de ligne
set autowriteall 			"Pour automatiquement sauvegarder les buffers modifiés lorsqu'on change de buffer
set pastetoggle=<F2>			"Pour activer/desactiver le mode paste afin de ne pas casser l'indentation à cause de autoindent
set lazyredraw				"On postpone la plupart des redraw que lorsque c'est explicitement necessaire (réduit la charge graphique)
set laststatus=2			"Toujours afficher la barre de status (pour airline)
set previewheight=24			"Hauteur de la preview window que l'on double (12 par défaut)
let mapleader = ','			"On définie le prefix key ou leader à ','
set nowildmenu
set mouse=""				" neovim active la souris par défaut, on l'enlève
let $NVIM_TUI_ENABLE_TRUE_COLOR=1 	" activation du mode true color


" Activation/initialisations de plugins
runtime! ftplugin/man.vim 	"Activation du plugin Man (:Man 2 printf)


" Options pour les plugins vim

"" airline
let g:airline_powerline_fonts = 1
let g:airline_theme = "kalisi"
let g:airline#extensions#tmuxline#enabled = 0
set timeoutlen=30
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
let g:airline#extensions#tabline#enabled = 1

"" showme
"let g:showme_debug = 1
let g:airline#extensions#showme#enabled = 1

"" conque
let g:ConqueTerm_TERM = 'xterm'
let g:ConqueTerm_Color = 1

"" neoterm
let g:neoterm_size = 20

" Mapping de raccourcis
map <C-l>     :set list!<CR>	"On utilise Ctrl-l comme toggle du mode listchars
map <C-n>     :nohlsearch<CR>	"On utilise Ctrl-n pour désactiver le hlsearch
map <C-right> :bnext<CR>	"On utilise Ctrl-right pour aller au buffer suivant
map <C-left>  :bprevious<CR>	"On utilise Ctrl-left pour aller au buffer précèdent
nnoremap K :Man <cword><CR>	"On utilise Shift-k pour lancer man sur le mot sous le curseur

" Code custom
function! RunAsyncCommand(cmdline)
	call neoterm#do(a:cmdline)
endfunction

function! OpenTodo()
	let l:path = findfile("TODO.txt", ".;")
	execute 'pedit' l:path
	wincmd p
endfunction

command! Todo call OpenTodo()
