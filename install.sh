#!/bin/sh

test -d $HOME/.vim/autoload || mkdir $HOME/.vim/autoload
ln -sf $HOME/.vim/pathogen/autoload/pathogen.vim $HOME/.vim/autoload/pathogen.vim
ln -sf $HOME/.vim/vimrc $HOME/.vimrc

