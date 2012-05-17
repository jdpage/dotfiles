# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=100000000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

PS1='\[\e[1;30m\][\[\e[1;31m\]\[$(printf "%.*s%.*s" $? $? $? " ")\[\e[1;30m\]\u@\h \[\e[1;37m\]$(shrinkpath "\w")\[\e[1;32m\]$(__git_ps1 ":%s")$(hg-ps1)\[\e[1;30m\]]\$\[\e[0m\] '

GPG_TTY=`tty` 
export GPG_TTY 

#case "$TERM" in
#xterm*|rxvt*|urxvt*)
#	PS1="\[\e]0;\u@\h: \w\a\]$PS1"
#	;;
#*)
#	;;
#esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

EDITOR=vim
export EDITOR
set -o vi

PAGER=less
export PAGER

# load in extensions
. ~/Code/ducttape/z.sh # http://github.com/rupa/z
. ~/Code/ducttape/s.sh # http://github.com/rupa/s

if [[ $TERM =~ "256color" ]]; then eval $( dircolors -b $HOME/.LS_COLORS ); fi

GOROOT=$HOME/Apps/go
GOOS=linux
GOARCH=amd64
export GOROOT GOOS GOARCH

export TIGCC=/usr/local/tigcc                                           
export PATH=$PATH:$TIGCC/bin:$HOME/.cabal/bin
