# path zshenv
case ${OSTYPE} in
	linux*)
		export PATH="$HOME/local/bin:$PATH"
		export PATH="/usr/local/cuda-8.0/bin:$PATH"
		export PATH="/usr/local/openmpi/bin:$PATH"
		export LD_LIBRARY_PATH="/usr/local/openmpi/lib:$LD_LIBRARY_PATH"
		export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH"
		export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"
		export CPATH="/usr/local/include:$CPATH"
		;;
	darwin*)
		export PATH="/Applications/MATLAB_R2018a.app/bin:$PATH"
		source ~/google-cloud-sdk/path.zsh.inc
		source ~/google-cloud-sdk/completion.zsh.inc
		;;
esac
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local:$PATH"
export PATH="/opt/local/sbin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/sh:$PATH"

# general {{{
# prompt
autoload -U colors
# user name display
PROMPT='%F{magenta}%n%F{red}@%m%b%f:%c%f $ '
# LSCOLORS <man ls>
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# bind key for delete
bindkey "^[[3~" delete-char
# ビープを無効にする
setopt no_beep
setopt no_hist_beep
setopt no_list_beep

# Shift-Tabで候補を逆順に補完する
bindkey '^[[Z' reverse-menu-complete
# 補完キー連打で候補順に自動で補完する
setopt auto_menu
# コマンドのオプションや引数を補完する
autoload -Uz compinit && compinit -u
## sudo の時にコマンドを探すパス
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# }}}

# alias {{{
alias ll='ls -l'
alias la='ls -1a'
alias vi='nvim'
alias tm='tmux'
alias m4a2wav='afconvert -f WAVE -d LEI16'
case ${OSTYPE} in
	darwin*)
		alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"
		alias chrome="open /Applications/Google\ Chrome.app/ --args --proxy-server=\"socks5://127.0.0.1:1080\""
		alias time="/usr/bin/time"
		;;
esac
# }}}

# history {{{
# 履歴をすぐに追加する（通常はシェル終了時）
setopt inc_append_history
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# history
HISTFILE=~/.zsh_history
HISTSIZE=100000 SAVEHIST=100000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history    # share command history data
# }}}

# peco history{{{
function peco-history-selection() {
case ${OSTYPE} in
	darwin*)
		BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
		;;
	linux*)
		BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
		;;
esac
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection
#}}}
# peco cd history {{{
# cdr
autoload -Uz add-zsh-hock
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

### search a destination from cdr list and cd the destination
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^Z' peco-cdr
# }}}
# peco kill{{{
#pecoでkill
function peco-pkill() {
  for pid in `ps aux | peco | awk '{ print $2 }'`
  do
    kill $pid
    echo "Killed ${pid}"
  done
}
alias pk="peco-pkill"
# }}}

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash)"

