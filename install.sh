#!/bin/sh

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
ln -sf $HOME/.vim/vimrc $HOME/.vimrc
ln -sf $HOME/.vim/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/.vim/screenrc $HOME/.screenrc
ln -sf $HOME/.vim $HOME/.config/nvim
ln -sf $HOME/.vim/vimrc $HOME/.config/nvim/init.vim
vim +BundleInstall +qall

echo "Remaining tasks:"
echo " * install powerline fonts (https://github.com/powerline/fonts.git)"

