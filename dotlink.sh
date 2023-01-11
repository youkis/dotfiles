#!/bin/bash
./dotunlink.sh
mkdir -p ~/.config
lnks=(\
	.config/nvim \
	.vim \
	.vimrc \
	.zshrc \
	.tmux.conf \
	.gitconfig \
	.gitignore_global \
	)
for lnk in ${lnks[@]}
do
	ln -nfs $HOME/dotfiles/$lnk $HOME/$lnk
done
