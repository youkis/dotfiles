#!/bin/bash
lnks=(\
	.config/nvim \
	.zshrc \
	.tmux.conf \
	)
for lnk in ${lnks[@]}
do
	unlink $HOME/$lnk
done

