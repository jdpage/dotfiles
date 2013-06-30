# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=100000000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# PS1='\[\e[1;30m\][\[\e[1;31m\]\[$(printf "%.*s%.*s" $? $? $? " ")\[\e[1;30m\]\u@\h \[\e[1;37m\]$(shrinkpath "\w")\[\e[1;32m\]$(__git_ps1 ":%s")$(hg-ps1)\[\e[1;30m\]]\$\[\e[0m\] '
#PS1='\[\e[1;30m\][\[\e[1;31m\]\[$(printf "%.*s%.*s" $? $? $? " ")\[\e[1;30m\]\u@\h \[\e[1;37m\]$(shrinkpath "\w")\[\e[1;30m\]]\$\[\e[0m\] '
PS1='\[\e[1;32m\][\u@\[\e[0;33m\]\h \[\e[1;32m\]$($HOME/dotfiles/shrinkpath "\w")\[\e[1;32m\]]\$\[\e[0m\] '

GPG_TTY=`tty` 
export GPG_TTY 

#case "$TERM" in
#xterm*|rxvt*|urxvt*)
#	PS1="\[\e]0;\u@\h: \w\a\]$PS1"
#	;;
#*)
#	;;
#esac

if [ "$TERM" = "xterm" ]; then
    export TERM="xterm-color" # stupid vte
fi

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

EDITOR="gvim -f"
export EDITOR
set -o vi

PAGER=less
export PAGER

# load in extensions
. ~/Code/ducttape/z.sh # http://github.com/rupa/z
. ~/Code/ducttape/s.sh # http://github.com/rupa/s

DIRCOLORS=dircolors
if [ -x /usr/local/bin/gdircolors ]; then
    DIRCOLORS=gdircolors
fi

if [[ $TERM =~ "256color" ]]; then eval $( $DIRCOLORS -b $HOME/.LS_COLORS ); fi

export PATH=$HOME/.cabal/bin:$PATH:/usr/local/go/bin

eval $(gnome-keyring-daemon --start)
SSH_ASKPASS=/usr/libexec/openssh/ssh-askpass
export GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO SSH_ASKPASS

eval $(env-music)

source "$HOME/src/todo-cli/todo.txt_cli-2.9/todo_completion"
complete -F _todo t
export TODOTXT_DEFAULT_ACTION=ls
