#!/bin/sh

test -d $HOME/.vim/autoload || mkdir $HOME/.vim/autoload
ln -sf $HOME/.vim/pathogen/autoload/pathogen.vim $HOME/.vim/autoload/pathogen.vim
ln -sf $HOME/.vim/vimrc $HOME/.vimrc
ln -sf $HOME/.vim/tmux.conf $HOME/.tmux.conf

echo "Remember to put TERM=xterm-256color in your ~/.bashrc"

