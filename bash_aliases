#!/bin/bash

alias nano='nano -w'

alias ..='cd ..'
alias ...='cd ../..'
alias lsd='ls -X --group-directories-first'
alias chmox='chmod +x'

# alias commit='hg commit'
# alias pull='hg pull'
# alias push='hg push'
# commitpush () { hg commit $* && hg push; }
# arcopush () { hg addremove && hg commit $* && hg push; }
# alias pullupdate='hg pull && hg update'

alias yum='sudo yum'
alias yumi='sudo yum install'
alias yumu='sudo yum upgrade'
alias yums='sudo yum search'
alias yumd='sudo yum erase'

alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"
alias backup="rsync -avh --delete --progress --stats --exclude 'Disks' $HOME/ /media/backup-linux/jdpage/"

alias ssh="TERM=xterm ssh"

alias math="rlwrap math"
