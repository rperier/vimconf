#!/bin/sh

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
ln -sf $HOME/.vim/vimrc $HOME/.vimrc
ln -sf $HOME/.vim/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/.vim/screenrc $HOME/.screenrc
vim +BundleInstall +qall

echo "Remaining tasks:"
echo " * export TERM=screen-256color in your ~/.bashrc"
echo " * install powerline fonts (https://github.com/powerline/fonts.git)"

