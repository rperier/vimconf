#!/bin/sh

ln -sf $HOME/.vim/vimrc $HOME/.vimrc
ln -sf $HOME/.vim/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/.vim/screenrc $HOME/.screenrc
ln -sf $HOME/.vim/zshrc $HOME/.zshrc
ln -sf $HOME/.vim $HOME/.config/nvim
ln -sf $HOME/.vim/vimrc $HOME/.config/nvim/init.vim
test -d $HOME/.mutt || mkdir $HOME/.mutt
ln -sf $HOME/.vim/mutt-aliases $HOME/.mutt/aliases
ln -sf $HOME/.vim/muttrc $HOME/.muttrc
ln -sf $HOME/.vim/lapis256.muttrc $HOME/.mutt/lapis256.muttrc
test -d $HOME/.config/terminator || mkdir $HOME/.config/terminator
ln -sf $HOME/.vim/terminator-config $HOME/.config/terminator/config 
if [ ! -e $HOME/.config/nvim/autoload/plug.vim ]; then
	curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall
fi

echo "Remaining tasks:"
echo " * install terminator with vte3 support (for true colors)"
echo " * install tmux-git with Tc support"
echo " * install powerline fonts (https://github.com/powerline/fonts.git)"

