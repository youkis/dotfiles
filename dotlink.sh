#!/bin/bash
./dotunlink.sh
mkdir -p ~/.config
lnks=(\
	.config/nvim \
	.zshrc \
	.tmux.conf \
	)
for lnk in ${lnks[@]}
do
	ln -nfs $HOME/dotfiles/$lnk $HOME/$lnk
done
