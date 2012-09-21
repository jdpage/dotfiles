#!/bin/bash

alias nano='nano -w'

LS=ls
if [ -x /usr/local/bin/gls ]; then
    LS=gls
fi

alias ls="$LS --color=auto -F"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias lsd="ls -X --group-directories-first"
alias chmox='chmod +x'

alias yum='sudo yum'
alias yumi='sudo yum install'
alias yumu='sudo yum upgrade'
alias yums='sudo yum search'
alias yumd='sudo yum erase'

alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"
# alias backup="rsync -avh --delete --progress --stats --exclude 'Disks' $HOME/ /media/backup-linux/jdpage/"

alias urxvt="urxvt256c"
