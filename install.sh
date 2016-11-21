#!/bin/sh

ln -sf $HOME/.vim/vimrc $HOME/.vimrc
ln -sf $HOME/.vim/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/.vim/screenrc $HOME/.screenrc
ln -sf $HOME/.vim/zshrc $HOME/.zshrc
ln -sf $HOME/.vim $HOME/.config/nvim
ln -sf $HOME/.vim/vimrc $HOME/.config/nvim/init.vim
test -d $HOME/.mutt || mkdir $HOME/.mutt
install -m 644 mutt-aliases $HOME/.mutt
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall

echo "Remaining tasks:"
echo " * install terminator with vte3 support (for true colors)"
echo " * install tmux-git with Tc support"
echo " * install powerline fonts (https://github.com/powerline/fonts.git)"

