#!/bin/bash
lnks=(\
	.config/nvim \
	.vim \
	.vimrc \
	.zshrc \
	.tmux.conf \
	)
for lnk in ${lnks[@]}
do
	unlink $HOME/$lnk
done

