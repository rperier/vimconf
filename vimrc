set nocompatible              " be iMproved, required
filetype off

set autoindent  	"activer l'indentation automatique,recopie l'indentation de la ligne précèdente
set t_Co=256		"activer le mode 256 couleurs
set hlsearch    	"activer le highlight lors des recherches
colorscheme lapis256 	"activer le colorschme lapis256
syntax on		"activer la colorisation syntaxique

" Activation du plugin stock Man (:Man 2 printf)
runtime! ftplugin/man.vim

" Pour afficher les tabulations en début de ligne ou les espaces en fin de ligne
set listchars=tab:▸\ ,trail:␣,nbsp:¤

" Pour automatiquement sauvegarder les buffers modifiés lorsqu'on change de buffer
set autowriteall

" Initialisation de pathogen
call pathogen#infect()
call pathogen#helptags()


" Mapping de raccourcis

"On utilise la touche <Fn> pour switcher à chaque buffer n
for i in [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
	exe 'map <F'.i.'> :b'.i.'<CR>'
endfor
map <C-l>     :set list!<CR>	"On utilise Ctrl-l comme toggle du mode listchars
map <C-n>     :nohlsearch<CR>	"On utilise Ctrl-n pour désactiver le hlsearch
map <C-right> :bnext<CR>	"On utilise Ctrl-right pour aller au buffer suivant
map <C-left>  :bprevious<CR>	"On utilise Ctrl-left pour aller au buffer précèdent

