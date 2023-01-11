#!/bin/bash
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
	unlink $HOME/$lnk
done

