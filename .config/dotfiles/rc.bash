alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

PS1='[\u@\h $($HOME/.config/dotfiles/shrinkpath "\w")]$ '
